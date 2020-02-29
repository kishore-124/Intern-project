class UserMailer <ApplicationMailer
  default from: 'kishore@mallow-tech.com'
  def invite(user)
    @user = user
    mail to: @user.mail
  end
end