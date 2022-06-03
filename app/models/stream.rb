# TODO :reek:SimulatedPolymorphism and :reek:TooManyStatements
class Stream < ApplicationRecord
  LOGFILE = Rails.root.join("log/stream_thoughts.log")

  has_and_belongs_to_many :users

  # Make sure our users exist
  validates_associated :users

  # `limit` must be a number
  validates :limit, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  # `created` cannot be present alongside `created_ago` or `created_range`
  validates :created_ago, :created_range, absence: true, if: -> { created.present? }

  # `updated` cannot be present alongside `updated_ago` or `updated_range`
  validates :updated_ago, :updated_range, absence: true, if: -> { updated.present? }

  #
  # `created` and `updated` must be a datetime
  #
  # I've tried and failed to get AR to pass anything but a valid date or nil to
  # a datetime field so I've removed the validations.
  #

  # `created_ago` and `updated_ago` must be an interval
  validates_each %i[ created_ago updated_ago ] do |record, attr, value|
    next unless value.present?

    unless value.is_a?(ActiveSupport::Duration)
      record.errors.add(attr, "value must be kind_of?(ActiveSupport::Duration)")
    end
  end

  # `created_range` and `updated_range` must be a daterange
  validates_each %i[ created_range updated_range ] do |record, attr, value|
    next unless value.present?

    unless value.is_a?(Range)
      record.errors.add(attr, "value must be kind_of?(Range)")
      next
    end

    unless value.begin.is_a?(Date) || value.begin.is_a?(Time)
      record.errors.add(attr, "value.begin must be kind_of?(Date || Time)")
    end

    unless value.end.is_a?(Date) || value.end.is_a?(Time)
      record.errors.add(attr, "value.end must be kind_of?(Date || Time)")
    end
  end

  # `all_tags` and `any_tags` must be arrays, will always be strings
  validates_each %i[ all_tags any_tags ] do |record, attr, value|
    next unless value.present?
    record.errors.add(attr, "value must be kind_of?(Array)") unless value.is_a?(Array)
  end

  # `author_ids` must contain valid, existing user_ids
  validates_each :author_ids do |record, attr, value|
    next unless value.present?

    unless value.is_a?(Array)
      record.errors.add(attr, "value must be kind_of?(Array)")
      next
    end

    unless value.reject { |uid| User.where(id: uid).blank? }.present?
      record.errors.add(attr, "each element must be an existing user_id")
    end
  end

  # invalid unless at least one field is present
  validate do
    unless present_filter_attributes.present?
      errors.add(:base, "at least one attribute must be present")
    end
  end

  # Maps an attribute to the value that needs to be fed to `Thought.where`
  #
  # The value is a proc/lambda that returns a Hash or String that gets passed
  # to `Thought.where` for filtering.
  #
  QUERY_MAP = {
    # TODO: tags, pg_search content
    # %i[ all_tags ] =>
    #   ->(attr, value) { %Q[tags @> "{#{value.join(',')}}"] },

    # %i[ any_tags ] =>
    #   ->(attr, value) { %Q[tags <@ "{#{value.join(',')}}"] },

    %i[ author_ids ] =>
      ->(attr, value) { { user: value } },

    %i[ created updated ] =>
      ->(attr, value) { { "#{attr}_at" => value } },

    %i[ created_ago updated_ago ] =>
      ->(attr, value) { { "#{attr[0, 7]}_at" => value.ago .. Time.current } },

    %i[ created_range updated_range ] =>
      ->(attr, value) { { "#{attr[0, 7]}_at" => value } }
  }
  QUERY_MAP.default = ->(attr, value) { { attr => value } }

  NON_FILTER_ATTRIBUTES = %i[ id created_at limit updated_at ]

  # Returns all Thoughts that match the Stream's filter fields
  # Accepts an optional limit to override the Stream's own limit (if present)
  #
  # All dates/times are UTC, but displayed in America/Chicago (for now)
  # TODO: localize date/time display to user's timezone
  #
  # field name, db type -> ruby type
  #
  # all_tags, string[] -> Array of Strings
  #   select: Thoughts tagged with EVERY tag in the array
  #     i.e.: ["tag1", "tag2"] selects Thoughts tagged with "tag1" AND "tag2"
  #
  # any_tags, string[] -> Array of Strings
  #   select: Thoughts tagged with ANY tag in the array
  #     i.e.: ["tag1", "tag2"] selects Thoughts tagged with "tag1" OR "tag2"
  #
  # author_ids, bigint[] -> Array of Integers
  #   select: Thoughts authored by any of the ids
  #     note: this isn't named `user_ids` because AR HABTM
  #
  # content, string -> String
  #   use pg_search to search the contents of Thoughts
  #
  # created, datetime -> ActiveSupport::TimeWithZone
  #   select: Thoughts with the exact created_at
  #     note: validation error if present alongside `created_ago` or `created_range`
  #
  # created_ago, interval -> ActiveSupport::Duration
  #   select: Thoughts with created_at between now and the given interval into the past
  #     i.e.: 3.days or "3 days" selects Thoughts with created_at within the last 3 days
  #     note: validation error if present alongside `created`
  #
  # created_range, daterange -> Range(Date .. Date)
  #   select: Thoughts with created_at within the Range
  #     note: validation error if present alongside `created`
  #
  # limit, integer -> Integer
  #   select: the number of Thoughts specified as the maximum
  #
  # updated, datetime -> ActiveSupport::TimeWithZone
  #   select: Thoughts with the exact updated_at
  #     note: validation error if present alongside `updated_ago` or `updated_range`
  #
  # updated_ago, interval -> ActiveSupport::Duration
  #   select: Thoughts with updated_at between now and the given interval into the past
  #     i.e.: 3.days or "3 days" selects Thoughts with created_at within the last 3 days
  #     note: validation error if present alongside `updated`
  #
  # updated_range, daterange -> Range
  #   select: Thoughts with updated_at within the Range
  #     note: validation error if present alongside `updated`
  #
  def thoughts(my_limit = nil)
    my_limit ||= limit
    thoughts = Thought.all

    log_title "#thoughts"

    log_time "processing filter" do
      present_filter_attributes.each do |attr|
        value = send(attr)

        log_sub "#{attr}: #{value}"

        key = QUERY_MAP.keys.find { |key| attr == key || attr.in?(key) }
        fmt = QUERY_MAP.fetch(key, QUERY_MAP.default)

        thoughts = thoughts.where(fmt.call(attr, value))
      end

      thoughts.count
    end

    log_title "complete"

    my_limit.nil? || my_limit.zero? ? thoughts : thoughts.limit(my_limit)
  end

  # Returns a list the model's attributes used for filtering
  def all_filter_attributes
    attribute_names.map(&:to_sym).reject { |attr| attr.in?(non_filter_attributes) }
  end

  private
    # Returns a list of the model's attributes used for filtering, minus empties
    def present_filter_attributes
      all_filter_attributes.reject { |attr| send(attr).blank? }
    end

    # A list of the model's attributes not used for filtering
    def non_filter_attributes
      NON_FILTER_ATTRIBUTES
    end

    def logger
      @logger ||= Logger.new(LOGFILE)

      @logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime.strftime("%Y-%m-%d %H:%M:%S")}] [#{severity.downcase}] #{msg}\n"
      end

      @logger
    end

    def log_title(message)
      text = "#{id} Stream: #{message}"
      length = [0, 45 - text.length].max
      logger.debug "== %s %s" % [text, "=" * length]
    end

    def log(message)
      logger.debug "-- #{message}"
    end

    def log_sub(message)
      logger.debug "   -> #{message}"
    end

    def log_time(message)
      log message

      result = nil
      time = Benchmark.measure { result = yield }

      log "%.4fs" % time.real
      log("#{result} rows") if result.is_a?(Integer)

      result
    end
end
