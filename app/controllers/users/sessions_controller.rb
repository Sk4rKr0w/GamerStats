# app/controllers/users/sessions_controller.rb
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
      sign_in(user)
      session[:user_id] = user.id
      session.delete(:pre_2fa_user_id)
      redirect_to root_path, notice: 'Successfully authenticated'
    else
      redirect_to new_user_session_path, alert: 'Invalid two-factor code'
    end
  end
end
