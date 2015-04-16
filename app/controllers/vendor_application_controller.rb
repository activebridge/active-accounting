class VendorApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def current_vendor
    session[:vendor_id] ? Vendor.find(session[:vendor_id]) : nil
  end

  def redirect_to_new_session
    redirect_to vendor_login_path unless session[:vendor_id]
  end

  def default_serializer_options
    { root: false }
  end
end
