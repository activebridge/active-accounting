class VendorHomeController < VendorApplicationController
  before_filter :redirect_to_new_session

  layout :counterparty_layout

  def index
    gon.current_counterparty = VendorSerializer.new(current_counterparty)
  end

  private

  def counterparty_layout
    current_counterparty.vendor? ? 'angular_vendor' : 'angular_hr'
  end
end
