# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
  
    def index
      @users = User.all
    end
  
    def show
      @user = User.find(params[:id])
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully deleted.'
    end
  
    def ban
        @user = User.find(params[:id])
        ban_duration = params[:ban_duration].to_i.minutes
        @user.update(banned_until: Time.current + ban_duration)
        redirect_to admin_users_path, notice: 'User was successfully banned.'
      end
  
    def warn
      @user = User.find(params[:id])
      # Render the warn view
    end
  
    def send_warning
      @user = User.find(params[:id])
      message = params[:message]
      UserMailer.warn_user(@user, message).deliver_now
      redirect_to admin_users_path, notice: 'User was successfully warned.'
    end
  
    private
  
    def check_admin
      redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user.admin?
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  