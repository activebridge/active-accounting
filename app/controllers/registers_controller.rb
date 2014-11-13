class RegistersController < ApplicationController
  before_action :parse_month, only: :destroy
  before_action :find_register, only: [:destroy, :update]

  def index
    register = Register.by_article(params[:article_id]).by_counterparty(params[:counterparty_id]).by_date(params[:date]).by_value(params[:value]) unless params[:month]
    register = Register.order('created_at desc').by_month(parse_month) if params[:month]
    json = ActiveModel::ArraySerializer.new(register,
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

  def update
    if @register.update_attributes(register_params)
      render json: RegisterSerializer.new(@register), status: 201
    else
      render json: {status: :error, error: @register.errors.messages, id: @register.id}, status: 422
    end
  end
  private

  def register_params
    params.require(:register).permit!
  end

  def find_register
    @register = Register.find params[:id]
  end

  def parse_month
    @month = params[:month].blank? ? Date.today : Date.parse(params[:month])
  end

end
