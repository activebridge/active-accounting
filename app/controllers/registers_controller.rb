class RegistersController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(Register.all,
                                           each_serializer: RegisterSerializer,
                                           root: nil)
    render json: json, status: 200
  end
end
