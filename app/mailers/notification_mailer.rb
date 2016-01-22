class NotificationMailer < ActionMailer::Base
  default from: 'robot@accounting.active-bridge.com'

  def vendor_add_hours(vendor, hour, token)
    @token = token
    @vendor = vendor
    @hour = hour
    mail(to: vendor.email, subject: 'Оповіщення про необхідність додання витрачених годин на клієнта').deliver!
  end

  def admin_auto_add_hours(hour)
    @hour = hour
    mail(to: 'eugene@active-bridge.com', subject: 'Звіт про підтвердження додавання годин постачальників').deliver!
  end
end
