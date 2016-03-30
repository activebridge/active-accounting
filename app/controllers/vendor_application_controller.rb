class VendorApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  helper_method :current_counterparty

  def current_counterparty
    token = request.headers['Authorization'].to_s.split(' ').last
    return @current_counterparty ||= Counterparty.find_by_auth_token(token) if token
    return @current_counterparty ||= Counterparty.find(params[:counterparty_id]) if params[:counterparty_id]
    return @current_counterparty ||= Counterparty.find(session[:counterparty_id]) if session[:counterparty_id]
  end

  def redirect_to_new_session
    redirect_to vendor_login_path unless current_counterparty
  end

  def redirect_to_hr_manager
    redirect_to vendor_profile_path + '#/hr_manager' if current_counterparty.try(:hr?)
  end

  def default_serializer_options
    { root: false }
  end
end
