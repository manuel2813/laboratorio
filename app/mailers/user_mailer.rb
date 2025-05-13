class UserMailer < ApplicationMailer
  default from: "postmaster@sandboxd36a4a8291804e9d916e5eed4c72b629.mailgun.org"

  def verification_email
    @user = params[:user]
    mail(to: @user.email, subject: "Verifica tu cuenta en GreenLab UNAS")
  end
end
