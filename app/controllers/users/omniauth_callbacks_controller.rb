class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      session[:user_id] = user.id # Aggiornamento della sessione
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
    else
      session['devise.google_data'] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: 'Email not found. Please sign up.'
    end
  end

  protected

  def after_omniauth_failure_path_for(scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end
end
