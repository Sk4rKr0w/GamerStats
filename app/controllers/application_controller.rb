class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_banned

  include Devise::Controllers::Helpers


  private

  def check_banned
    if user_signed_in? && current_user.banned?
      sign_out current_user
      redirect_to new_user_session_path, alert: "Your account has been banned until #{current_user.banned_until}."
    end
  end

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
