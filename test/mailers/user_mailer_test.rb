require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    mail = UserMailer.welcome
    assert_equal "Welcome", mail.subject
    assert_equal ["c.poniard@gmail.com"], mail.to
    assert_equal ["c.poniard@gmail.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  def welcom
    user = @current_user
    UserMailer.welcome(user)
  end

end
