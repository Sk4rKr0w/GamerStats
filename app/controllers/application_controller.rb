class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :riot_id, :battle_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password, :riot_id, :battle_id])
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
