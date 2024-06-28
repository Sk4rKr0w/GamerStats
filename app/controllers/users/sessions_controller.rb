class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      user.send_two_factor_code
      session[:user_id] = user.id
      redirect_to user_two_factor_path
    else
      super
    end
  end

  def two_factor
    # Questo metodo mostra la vista per inserire il codice di verifica
  end

  def verify_two_factor
    user = User.find(session[:user_id])

    if user&.verify_two_factor_code(params[:code])
      sign_in(user)
      session.delete(:user_id)
      redirect_to root_path, notice: 'Successfully authenticated'
    else
      redirect_to new_user_session_path, alert: 'Invalid two-factor code'
    end
  end
end