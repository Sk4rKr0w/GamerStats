class UserMailer < ApplicationMailer
    default from: 'admin@yourapp.com'


    def two_factor_code(user)
      @user = user
      mail(to: @user.email, subject: 'Your Two-Factor Code')
    end

    def warn_user(user, message)
      @user = user
      @message = message
      mail(to: @user.email, subject: 'Warning')
    end
end
  