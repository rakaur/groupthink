# TODO :reek:SimulatedPolymorphism and :reek:TooManyStatements
class Group < ApplicationRecord
  has_and_belongs_to_many :filters
  has_and_belongs_to_many :users

  # Make sure our associations exist
  validates_associated :filters
  validates_associated :users

  # Execute all the filters to return the collective results
  def thoughts
    return Thought.none unless filters.present?

    thoughts = Thought.all

    # TODO: for now, each query is an and(), put a setting with has_many :through
    filters.each { |f| thoughts = thoughts.and(f.query) }

    thoughts
  end
end
