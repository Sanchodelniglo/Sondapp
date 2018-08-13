if Rails.env.development?
  require "email_interceptor"
  ActionMailer::Base.register_interceptor(EmailInterceptor)
end

if Rails.env.production?
  require "email_interceptor"
  ActionMailer::Base.register_interceptor(EmailInterceptor)
end