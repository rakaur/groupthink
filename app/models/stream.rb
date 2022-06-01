class Stream < ApplicationRecord
  has_and_belongs_to_many :users

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
    puts "#" * 80
    puts "Processing Thoughts for Stream#{id}"

    thoughts = Thought.all
    my_limit ||= limit

    # string[] -> Array of Strings
    # TODO: implement tags
    if all_tags.present?
      puts "Would search for all tags"
    end

    # string[] -> Array of Strings
    # TODO: implement tags
    if any_tags.present?
      puts "Would search for any tags"
    end

    # bigint[] -> Array of Integers
    if author_ids.present?
      puts "Selecting Thoughts by user #{author_ids.inspect}"
      thoughts = thoughts.where(user: author_ids)
    end

    # string -> String
    # TODO: pg_search
    if content.present?
      puts "Would search for content"
    end

    # datetime -> ActiveSupport::TimeWithZone
    if created.present?
      puts "Selecting Thoughts created_at #{created.inspect}"
      thoughts = thoughts.where(created_at: created)
    end

    # interval -> ActiveSupport::Duration
    if created_ago.present? && created.blank?
      puts "Selecting Thoughts by created_ago #{created_ago.inspect}"
      thoughts = thoughts.where(created_at: created_ago.ago .. Time.current)
    end

    # daterange -> Range(Date .. Date)
    if created_range.present? && created.blank?
      puts "Selecting Thoughts by created_range #{created_range.inspect}"
      thoughts = thoughts.where(created_at: created_range)
    end

    # datetime -> ActiveSupport::TimeWithZone
    if updated.present?
      puts "Selecting Thoughts updated_at #{updated.inspect}"
      thoughts = thoughts.where(updated_at: created)
    end

    # interval -> ActiveSupport::Duration
    if updated_ago.present? && updated.blank?
      puts "Selecting Thoughts by updated_ago #{updated_ago.inspect}"
      thoughts = thoughts.where(updated_at: updated_ago.ago .. Time.current)
    end

    # daterange -> Range(Date .. Date)
    if updated_range.present? && updated.blank?
      puts "Selecting Thoughts by updated_range #{updated_range.inspect}"
      thoughts = thoughts.where(created_at: updated_range)
    end

    my_limit ? thoughts&.limit(my_limit) : thoughts
  end
end

__END__

  # content = {
  #   where: {
  #     user_id: Integer,
  #     content: String,
  #     created_at: DateTime,
  #     updated_at: DateTime
  #   },
  #
  #   all: true,
  #   created_ago_start: Integer, # number of seconds ago, ActiveSupport::Duration.to_json
  #   created_ago_stop: Integer
  # }

  # Returns all matching thoughts
#   def thoughts(limit = nil)
#     thoughts = Thought.all
#
#
#     content.each do |key, value|
#       case key
#       when "all"
#         thoughts = thoughts.where(created_at: 1.month.ago .. Time.current)
#         break
#       when "created_ago_start"
#         start = ActiveSupport::Duration.build(content["created_ago_start"].to_i).ago
#
#         if content["created_ago_stop"].present?
#           stop = ActiveSupport::Duration.build(content["created_ago_stop"].to_i).ago
#         else
#           stop = Time.current
#         end
#
#         thoughts = thoughts.where(created_at: start .. stop)
#       when "where"
#         thoughts = thoughts.where(content[key])
#       else
#         # TODO: Unknown key, ignore for now ?
#       end
#     end
#
#     limit ? thoughts&.order(created_at: :desc)&.limit(limit) : thoughts&.order(created_at: :desc)
#   end
# end
