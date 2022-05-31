class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable

  has_and_belongs_to_many :streams
  has_many :thoughts

  def default_stream
    Stream.first
  end

  def to_s
    Digest::SHA1.hexdigest(id.to_s)[.. 8]
  end
end
