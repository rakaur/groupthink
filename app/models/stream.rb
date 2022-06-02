class Stream < ApplicationRecord
  has_and_belongs_to_many :users

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
  #     note: that ids aren't confirmed references to existing users
  #           this isn't named `user_ids` because AR HABTM
  #
  # content, string -> String
  #   use pg_search to search the contents of Thoughts
  #
  # created, datetime -> ActiveSupport::TimeWithZone
  #   select: Thoughts with the exact created_at
  #     note: if this is present alongside `created_range` or `created_within`
  #           they will be ignored
  #
  # created_ago, interval -> ActiveSupport::Duration
  #   select: Thoughts with created_at between now and the given interval into the past
  #     i.e.: 3.days or "3 days" selects Thoughts with created_at within the last 3 days
  #
  # created_range, daterange -> Range(Date .. Date)
  #   select: Thoughts with created_at within the Range
  #     note: will be ignored if present alongside `created`
  #
  # limit, integer -> Integer
  #   select: the number of Thoughts specified as the maximum
  #
  # updated, datetime -> ActiveSupport::TimeWithZone
  #   select: Thoughts with the exact updated_at
  #     note: if this is present alongside `updated_range` or `updated_within`
  #           will be ignored
  #
  # updated_ago, interval -> ActiveSupport::Duration
  #   select: Thoughts with updated_at between now and the given interval into the past
  #     i.e.: 3.days or "3 days" selects Thoughts with created_at within the last 3 days
  #
  # updated_range, daterange -> Range
  #   select: Thoughts with updated_at within the Range
  #     note: will be ignored if present alongside `updated`
  #
  def thoughts(my_limit = nil)
    announce "#thoughts"

    thoughts = Thought.all
    my_limit ||= limit

    say_with_time "processing filter" do
    # string[] -> Array of Strings
    # TODO: implement tags
    if all_tags.present?
      # say "all_tags: ", true
    end

    # string[] -> Array of Strings
    # TODO: implement tags
    if any_tags.present?
      # say "any_tags: ", true
    end

    # bigint[] -> Array of Integers
    if author_ids.present?
      say "author_ids: #{author_ids.inspect}", true

      thoughts = thoughts.where(user: author_ids)
    end

    # string -> String
    # TODO: pg_search
    if content.present?
      # say "content: ", true
    end

    # datetime -> ActiveSupport::TimeWithZone
    if created.present?
      say "created: #{created.inspect}", true
      thoughts = thoughts.where(created_at: created)
    end

    # interval -> ActiveSupport::Duration
    if created_ago.present? && created.blank?
      say "created_ago: #{created_ago.inspect}", true
      thoughts = thoughts.where(created_at: created_ago.ago .. Time.current)
    end

    # daterange -> Range(Date .. Date)
    if created_range.present? && created.blank?
      say "created_range: #{created_range.inspect}", true
      thoughts = thoughts.where(created_at: created_range)
    end

    # datetime -> ActiveSupport::TimeWithZone
    if updated.present?
      say "updated: #{updated.inspect}", true
      thoughts = thoughts.where(updated_at: updated)
    end

    # interval -> ActiveSupport::Duration
    if updated_ago.present? && updated.blank?
      say "updated_ago: #{updated_ago.inspect}", true
      thoughts = thoughts.where(updated_at: updated_ago.ago .. Time.current)
    end

    # daterange -> Range(Date .. Date)
    if updated_range.present? && updated.blank?
      say "updated_range: #{updated_range.inspect}", true
      thoughts = thoughts.where(updated_at: updated_range)
    end

    thoughts.count
    end
    announce "complete"
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

    def announce(message)
      text = "#{id} Stream: #{message}"
      length = [0, 45 - text.length].max
      logger.debug "== %s %s" % [text, "=" * length]
    end

    def say(message, subitem = false)
      logger.debug "#{subitem ? "   ->" : "--"} #{message}"
    end

    def say_with_time(message)
      say(message)
      result = nil
      time = Benchmark.measure { result = yield }
      say "%.4fs" % time.real, :subitem
      say("#{result} rows", :subitem) if result.is_a?(Integer)
      result
    end
end
