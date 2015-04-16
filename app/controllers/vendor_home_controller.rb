class VendorHomeController < VendorApplicationController
  before_filter :redirect_to_new_session
  layout 'angular_vendor'

  def index; end
end
