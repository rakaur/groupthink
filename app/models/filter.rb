class Filter < ApplicationRecord
  has_and_belongs_to_many :groups

  validates :filter_attribute, :comparison_type, presence: true

  # `compare_string_array` and `compare_integer_array` must be arrays
  validates_each %i[ compare_string_array compare_integer_array ] do |record, attr, value|
    next unless value.present?
    record.errors.add(attr, "value must be kind_of?(Array)") unless value.is_a?(Array)
  end

  # `compare_date` must be a date
  validates_each :compare_date do |record, attr, value|
    next unless value.present?
    record.errors.add(attr, "value must be kind_of?(Date)") unless value.is_a?(Date)
  end

  # `compare_daterange` must be a daterange
  validates_each :compare_daterange do |record, attr, value|
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

  # `compare_interval` must be an interval
  validates_each :compare_interval do |record, attr, value|
    next unless value.present?

    unless value.is_a?(ActiveSupport::Duration)
      record.errors.add(attr, "value must be kind_of?(ActiveSupport::Duration)")
    end
  end

  validate do
    next unless self.comparison_type.present?

    ct_attr = "compare_#{comparison_type}"
    unless self.send(ct_attr)
      errors.add(:base, "comparison_type is #{comparison_type} but #{ct_attr} is empty")
    end
  end

  # This maps the data type of the comparison to a query format
  # QUERY_MAP[column_type][comparison_type] = lambda that returns a hash for `where`
  #
  QUERY_MAP = {
    datetime:  {
      date:     ->(attr, cmp) { { attr => cmp.beginning_of_day .. cmp.end_of_day } },
      interval: ->(attr, cmp) { { attr => cmp.ago .. Time.current } }
    }
  }

  LOG_FILE = Rails.root.join("log/filter_query.log")
  LOG_DTF  = "%Y-%m-%d %H:%M:%S"
  LOG_FMT  = ->(l, d, _, m) { "[#{d.strftime(LOG_DTF)}] [#{l.downcase}] #{m}\n" }

  # Returns an unexecuted query chain
  def query
    from = caller&.first[/^.+\/(.+\/.+:\d+):.+$/i, 1]

    log_title "Filter[#{id}]#query begin"
    log "!! #{from}" if from

    attr = filter_attribute

    # If `filter_attribute` isn't a column, assume it's a relation and that
    # we're comparing against a foreign key
    #
    # We could do a bunch of fancy reflection checks to make sure it's an
    # association but our own data should be valid
    #
    col_type = Thought.column_for_attribute(attr).type || :integer
    log "#{attr} [#{col_type}]"

    cmp = send("compare_#{comparison_type}")
    log_sub "value: #{cmp} [#{comparison_type}]"

    # Get the specific formatter, or fall back to default
    qry = QUERY_MAP[col_type]&.fetch(comparison_type.to_sym, nil)&.(attr, cmp) || { attr => cmp }

    log_sub "query:"
    qry.pretty_inspect.split("\n").each { |l| log_sub_sub l }

    log_title "Filter[#{id}]#query end"

    Thought.where(qry)
  end

  private
    # def log_time(message = nil)
    #   log message if message
    #   result = nil
    #   time = Benchmark.measure { result = yield }
    #   "%.4fs" % time.real
    # end

    def logger
      @logger ||= Logger.new(LOG_FILE)
      @logger.formatter = LOG_FMT
      @logger
    end

    def log_title(message = "")
      length = [0, 45 - message.length].max
      logger.debug "== #{message} #{'=' * length}"
    end

    def log(message)
      logger.debug "-- #{message}"
    end

    def log_sub(message)
      logger.debug "   -> #{message}"
    end

    def log_sub_sub(message)
      text = "        #{message}"
      text = "#{text[0 ... 42]}..." if text.length > 45
      logger.debug text
    end
end
