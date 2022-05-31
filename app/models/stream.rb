class Stream < ApplicationRecord
  has_and_belongs_to_many :users

  def thoughts
    return Thought.where(created_at: 1.month.ago .. Time.now).limit(10) if content["all"]
    Thought.where(content).limit(10)
  end
end
