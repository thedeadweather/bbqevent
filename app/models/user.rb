class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

  has_many :events, dependent: :destroy
  has_many :comments
  has_many :subscriptions

  validates :name, presence: true, length: { maximum: 35 }

  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  mount_uploader :avatar, AvatarUploader

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # находим identity и текущего юзера если такие есть
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    # Создаем юзера если текущего нет
    if user.nil?
      # Достаём email из токена
      email = auth.info.email
      user = User.where(:email => email).first
      # если не найден по почте, то создаем нового
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          # если в токене нет почты, то создаем временную
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token.first(16)
        )
        user.save!
      end
    end
    #связываем identity с юзером
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  private

  def set_name
    self.name = "Комрат №#{rand(777)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).update_all(user_id: self.id)
  end
end
