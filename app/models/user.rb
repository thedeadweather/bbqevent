class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :events

  validates :name, presence: true, length: { maximum: 35 }
  validates :email, uniqueness: true, presence: true, length: { maximum: 255 }, format: { with: EMAIL_REGEX }
end
