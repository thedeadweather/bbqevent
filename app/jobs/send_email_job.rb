class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(model)
    event = model.event
    # собираем всех подписчиков и автора события в массив мэйлов, исключаем повторяющиеся
    all_emails =
      (event.subscriptions.map(&:user_email) + [event.user.email] - [model.user&.email]).uniq
    # отправляем уведомления в зависимости от действия пользователя
    case model
    when Subscription then EventMailer.subscription(event, model).deliver_later
    when Photo        then all_emails.each { |mail| EventMailer.photo(event, model, mail).deliver_later }
    when Comment      then all_emails.each { |mail| EventMailer.comment(event, model, mail).deliver_later }
    end
  end
end
