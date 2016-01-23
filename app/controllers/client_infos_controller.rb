class ClientInfosController < ApplicationController
  def update
    client_info = ClientInfo.find(params[:id])
    if client_info.update_attributes(client_info_params)
      render json: client_info, status: 201
    else
      render json: { status: :error, error: client_info.errors.messages }, status: 422
    end
  end

  private

  def client_info_params
    params.require(:client_info).permit!
  end
end
