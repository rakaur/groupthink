class Stream < ApplicationRecord
  has_and_belongs_to_many :users

  def thoughts
    return Thought.where(created_at: 1.month.ago .. Time.now) if content['all']
    Thought.where(content)
  end
end
