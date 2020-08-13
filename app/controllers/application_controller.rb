class ApplicationController < ActionController::Base
  include Pundit
  # настройка девайса при создании или обновлении юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # хелпер для авторизации пользователя при редактировании или удалении
  # коммента, фотографии или подписки на событие
  helper_method :current_user_can_edit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password, :password_confirmation, :current_password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :password, :password_confirmation, :current_password])
  end

  def current_user_can_edit?(model)
    user_signed_in? &&
    (model.user == current_user || (model.try(:event).present? && model.event.user == current_user))
  end

  # вызов исключения при ошибки авторизации Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = t('pundit.not_authorized')
    redirect_to(request.referrer || root_path)
  end
end
