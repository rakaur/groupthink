class Stream < ApplicationRecord
  has_and_belongs_to_many :users

  # Returns all matching thoughts
  def thoughts(limit = nil)
    thoughts = Thought.all

    content.first.each do |key, value|
      case key
      when "all"
        thoughts = thoughts.where(created_at: 1.month.ago .. Time.now)
        break
      when "created_range"
        thoughts = thoughts.where(created_at: eval(content.first[key]))
      when "where"
        thoughts = thoughts.where(content.first[key])
      else
        # TODO: Unknown key, ignore for now ?
      end
    end

    limit ? thoughts&.order(created_at: :desc)&.limit(limit) : thoughts&.order(created_at: :desc)
  end
end
