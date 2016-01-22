class VendorInfosController < ApplicationController
  def update
    vendor_info = VendorInfo.find(params[:id])
    if vendor_info.update_attributes(vendor_info_params)
      render json: vendor_info, status: 201
    else
      render json: { status: :error, error: vendor_info.errors.messages }, status: 422
    end
  end

  private

  def vendor_info_params
    params.require(:vendor_info).permit!
  end
end
