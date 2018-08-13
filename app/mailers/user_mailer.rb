class UserMailer < ApplicationMailer

  def welcome(current_user)
    @user = current_user
    mail(to: @user.email, subject: 'Welcome to our App')
    
    
  end
end
