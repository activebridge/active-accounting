class RegistersController < ApplicationController
  before_action :find_register, only: :destroy

  def index
    json = ActiveModel::ArraySerializer.new(Register.order('created_at desc'),
                                           each_serializer: RegisterSerializer,
                                           root: nil)
    render json: json, status: 200
  end

  def create
    register = Register.new(register_params)
    if register.save
      render json: RegisterSerializer.new(register), status: 200
    else
      render json: {status: :error, errors: register.errors.messages}, status: 422
    end
  end

  def destroy
    @register.destroy
    head(200)
  end

  private

  def register_params
    params.require(:register).permit!
  end

  def find_register
    @register = Register.find params[:id]
  end
end
