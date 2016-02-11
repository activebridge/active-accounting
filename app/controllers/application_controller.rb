class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  before_filter :set_paper_trail_whodunnit
  respond_to :html, :json

  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def after_sign_in_path_for(resource)
    return '#home'
  end

  alias_method :current_user, :current_admin
end
