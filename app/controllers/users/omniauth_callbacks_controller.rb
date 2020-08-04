class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    # добавляем колбеки для каждого провайдера
    class_eval %Q(
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted?
          flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: "#{provider}".capitalize)
          sign_in_and_redirect @user, event: :authentication
        else
          flash[:error] = I18n.t(
           'devise.omniauth_callbacks.failure',
           kind: "#{provider}".capitalize,
           reason: 'authentication error'
          )
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to root_path
        end
      end
    )
  end

  %i[vkontakte facebook].each do |provider|
    provides_callback_for provider
  end
end
