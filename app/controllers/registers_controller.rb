class RegistersController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(Register.all,
                                           each_serializer: RegisterSerializer,
                                           root: nil)
    render json: json, status: 200
  end

  def create
    register = Register.new(register_params)
    if register.save
      render json: RegisterSerializer.new(register), status: 200
    else
      render json: {status: :error, error: register.errors.messages}, status: 422
    end
  end

  private

  def register_params
    params.require(:register).permit!
  end
end
