class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      user.update(last_sign_in_at: Time.current) # Aggiornamento last_sign_in_at
      user.send_two_factor_code
      session[:pre_2fa_user_id] = user.id
      redirect_to user_two_factor_path
    else
      super
    end
  end

  def two_factor
    # Questo metodo mostra la vista per inserire il codice di verifica
  end

  def verify_two_factor
    user = User.find(session[:pre_2fa_user_id])

    if user&.verify_two_factor_code(params[:code])
      session[:user_id] = user.id
      sign_in(user)
      session.delete(:pre_2fa_user_id)
      redirect_to root_path, notice: 'Successfully authenticated'
    else
      redirect_to user_two_factor_path, alert: 'Invalid two-factor code'
    end
  end

  def resend_two_factor_code
    user = User.find(session[:pre_2fa_user_id])
    if user
      user.send_two_factor_code
      redirect_to user_two_factor_path, notice: 'A new two-factor code has been sent to your email.'
    else
      redirect_to new_user_session_path, alert: 'Unable to resend two-factor code. Please try again.'
    end
  end

  def cancel_two_factor
    session.delete(:pre_2fa_user_id)
    redirect_to new_user_session_path, notice: 'Two-factor authentication has been canceled.'
  end

  # Metodo per gestire l'accesso tramite OAuth
  def oauth
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)

    if user.persisted?
      user.update(last_sign_in_at: Time.current) # Aggiornamento last_sign_in_at
      user.send_two_factor_code
      session[:pre_2fa_user_id] = user.id
      redirect_to user_two_factor_path
    else
      session['devise.google_data'] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: 'Email not found. Please sign up.'
    end
  end
end
