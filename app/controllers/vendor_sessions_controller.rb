class VendorSessionsController < VendorApplicationController
  before_action :fetch_counterparty, only: :create

  def create
    if @counterparty
      session[:counterparty_id] = @counterparty.id
      @counterparty.update(signed_in: true)
    else
      flash.now[:error] = 'Invalid email or password'
    end

    respond_to do |format|
      format.js { render layout: false }
      format.json { render json: @counterparty }
    end
  end

  def destroy
    reset_session
    redirect_to vendor_login_path
  end

  private

  def fetch_counterparty
    @counterparty ||= Counterparty.find_by(email: params[:email], password: params[:password])
  end
end
