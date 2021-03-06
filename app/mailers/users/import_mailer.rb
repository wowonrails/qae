class Users::ImportMailer < ApplicationMailer
  def notify_about_release(user_id, raw_token)
    user = User.find(user_id)
    @token = raw_token
    @user = user
    mail to: user.email, subject: "The Queen's Awards for Enterprise: Welcome to our new application system"
  end
end
