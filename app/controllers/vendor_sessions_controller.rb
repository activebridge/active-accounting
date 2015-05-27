class VendorSessionsController < VendorApplicationController

  def new; end

  def create
    if find_vendor.nil?
      flash.now[:error] = 'Invalid email or password'
    else
      session[:vendor_id] = find_vendor.id
      find_vendor.update(signed_in: true) unless find_vendor.signed_in?
    end
    render layout: false
  end

  def destroy
    reset_session
    redirect_to vendor_login_path
  end

  private

  def find_vendor
    Vendor.find_by(email: params[:email], password: params[:password])
  end
end
