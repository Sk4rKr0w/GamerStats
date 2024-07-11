# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :check_if_banned, only: [:index]

  def index
    # Altre logiche del tuo controller
  end

  private

  def check_if_banned
    if current_user&.banned?
      banned_until = current_user.banned_until
      sign_out current_user
      redirect_to new_user_session_path, alert: "Your account has been banned until #{banned_until}."
    end
  end
end
