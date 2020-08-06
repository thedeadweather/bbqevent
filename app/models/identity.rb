class Identity < ApplicationRecord
  belongs_to :user, optional: true

  validates_presence_of :url, :provider
  validates_uniqueness_of :url, scope: :provider

  def self.find_for_oauth(auth)
    provider = auth.provider
    id = auth.extra.raw_info.id

    case provider
    when 'facebook'
      url = "https://facebook.com/#{id}"
    when 'vkontakte'
      url = "https://vk.com/id#{id}"
    end
    # Ищем в базе запись по провайдеру и урлу
    # Если есть, то вернётся, если нет, то будет создана новая
    find_or_create_by(url: url, provider: provider)
  end
end
