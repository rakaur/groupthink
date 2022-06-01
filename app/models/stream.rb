class Stream < ApplicationRecord
  has_and_belongs_to_many :users

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
  def thoughts(limit = nil)
    thoughts = Thought.all


    content.each do |key, value|
      case key
      when "all"
        thoughts = thoughts.where(created_at: 1.month.ago .. Time.current)
        break
      when "created_ago_start"
        start = ActiveSupport::Duration.build(content["created_ago_start"].to_i).ago

        if content["created_ago_stop"].present?
          stop = ActiveSupport::Duration.build(content["created_ago_stop"].to_i).ago
        else
          stop = Time.current
        end

        thoughts = thoughts.where(created_at: start .. stop)
      when "where"
        thoughts = thoughts.where(content[key])
      else
        # TODO: Unknown key, ignore for now ?
      end
    end

    limit ? thoughts&.order(created_at: :desc)&.limit(limit) : thoughts&.order(created_at: :desc)
  end
end
