class UserMailer < ApplicationMailer
    def two_factor_code(user)
      @user = user
      mail(to: @user.email, subject: 'Your Two-Factor Code')
    end
  end
  