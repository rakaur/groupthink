# TODO :reek:SimulatedPolymorphism and :reek:TooManyStatements
class Stream < ApplicationRecord
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
  # a datime field so I've removed the validations.
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
  validate :at_least_one
  def at_least_one
    attrs = attribute_names.map(&:to_sym).reject do |attr|
      attr if self.send(attr).blank? || attr.in?(%i[ id created_at updated_at ])
    end

    unless attrs.present?
      errors.add(:base, "at least one attribute must be present")
    end
  end

  LOGFILE = Rails.root.join("log/stream_thoughts.log")

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
    log_title "#thoughts"

    thoughts = Thought.all
    my_limit ||= limit

    now = Time.current

    log_time "processing filter" do
      # string[] -> Array of Strings
      # TODO: implement tags
      if all_tags.present?
        # log_sub "all_tags: "
      end

      # string[] -> Array of Strings
      # TODO: implement tags
      if any_tags.present?
        # log_sub "any_tags: "
      end

      # bigint[] -> Array of Integers
      if author_ids.present?
        log_sub "author_ids: #{author_ids.inspect}"

        thoughts = thoughts.where(user: author_ids)
      end

      # string -> String
      # TODO: pg_search
      if content.present?
        # log_sub "content: "
      end

      # datetime -> ActiveSupport::TimeWithZone
      if created.present?
        log_sub "created: #{created.inspect}"
        thoughts = thoughts.where(created_at: created)
      end

      # interval -> ActiveSupport::Duration
      if created_ago.present?
        log_sub "created_ago: #{created_ago.inspect}"
        thoughts = thoughts.where(created_at: created_ago.ago .. now)
      end

      # daterange -> Range(Date .. Date)
      if created_range.present?
        log_sub "created_range: #{created_range.inspect}"
        thoughts = thoughts.where(created_at: created_range)
      end

      # datetime -> ActiveSupport::TimeWithZone
      if updated.present?
        log_sub "updated: #{updated.inspect}"
        thoughts = thoughts.where(updated_at: updated)
      end

      # interval -> ActiveSupport::Duration
      if updated_ago.present?
        log_sub "updated_ago: #{updated_ago.inspect}"
        thoughts = thoughts.where(updated_at: updated_ago.ago .. now)
      end

      # daterange -> Range(Date .. Date)
      if updated_range.present?
        log_sub "updated_range: #{updated_range.inspect}"
        thoughts = thoughts.where(updated_at: updated_range)
      end

      thoughts.count
    end

    log_title "complete"
    my_limit ? thoughts&.limit(my_limit) : thoughts
  end

  private
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
