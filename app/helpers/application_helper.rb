module ApplicationHelper
  def fully_authenticated?
    user_signed_in? && session[:user_id].present?
  end
end