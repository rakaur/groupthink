class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable

  has_and_belongs_to_many :groups
  has_many :thoughts

  # TODO :reek:UtilityFunction
  def default_group
    Group.find(1)
  end

  # TODO: change this table to use uuid primary keys
  def to_s
    Digest::SHA1.hexdigest(id.to_s)[0 .. 8]
  end
end
