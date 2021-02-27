class UserMailer < ApplicationMailer
  def admin_invitation
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: "Invited to admin")
  end
end
