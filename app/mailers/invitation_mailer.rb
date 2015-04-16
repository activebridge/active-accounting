class InvitationMailer < ActionMailer::Base
  default from: "admin@accounting.active-bridge.com"

  def create_invite_for_vendor(user, password)
    @user = user
    @password = password
    mail(to: user.email, subject: 'Запрошення на управління естімейтами').deliver!
  end
end
