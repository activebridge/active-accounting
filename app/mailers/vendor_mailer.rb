class VendorMailer < ActionMailer::Base
  default from: "admin@accounting.active-bridge.com"

  def password_reset(vendor)
    @vendor = vendor
    mail to: vendor.email, subject: "Password Reset"
  end
end
