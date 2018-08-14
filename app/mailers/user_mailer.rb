class UserMailer < ApplicationMailer

  default from: 'c.poniard@gmail.com'
  layout 'mailer'

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to our App')
    
    
  end
end
