class NotificationMailer < ActionMailer::Base
  default from: "robot@accounting.active-bridge.com"

  def vendor_auto_add_hours(vendor, hour)
    @vendor = vendor
    @hour = hour
    mail(to: vendor.email, subject: 'Оповіщення про автоматичне додання витрачених годин на клієнта').deliver!
  end

  def admin_auto_add_hours(hours)
    @hours = hours
    mail(to: 'eugene@active-bridge.com', subject: 'Звіт про автоматичне додавання годин постачальників').deliver!
  end
end
