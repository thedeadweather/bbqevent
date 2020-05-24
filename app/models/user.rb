class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_name, on: :create
  validates :name, presence: true, length: { maximum: 35 }

  has_many :events

  private

  def set_name
    self.name = "Комрат №#{rand(777)}" if self.name.blank?
  end
end
