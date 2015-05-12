class VendorHomeController < VendorApplicationController
  before_filter :redirect_to_new_session
  layout 'angular_vendor'

  def index
    gon.current_vendor = VendorSerializer.new(current_vendor)
  end
end
