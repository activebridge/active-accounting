class ApplicationController < ActionController::Base
  before_filter :set_mailer_host
  before_action :authenticate_user!
  respond_to :html, :json

  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def after_sign_in_path_for(resource)
    return '#home'
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
