class VendorPasswordResetsController < VendorApplicationController
  def new; end

  def create
    vendor = Vendor.find_by_email(params[:email])
    vendor.send_password_reset if vendor
    redirect_to vendor_login_url, notice: "Email sent with password reset instructions."
  end

  def edit
    @vendor = Vendor.find_by_password_reset_token!(params[:id])
  end

  def update
    @vendor = Vendor.find_by_password_reset_token!(params[:id])
    if @vendor.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: "Password reset has expired."
    elsif @vendor.update_attributes(password_resets_params)
      redirect_to vendor_login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end

  def change_password
    if current_vendor.password == params[:current_password]
      current_vendor.update(password: params[:new_password])
      render json: { status: :ok }
    else
      render json: { status: :error }, status: 422
    end
  end

  private

  def password_resets_params
    params.require(:vendor).permit(:password)
  end
end
