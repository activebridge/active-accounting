class RegistersController < ApplicationController
  before_action :parse_month, only: :destroy
  before_action :set_model
  before_action :find_register, only: [:destroy, :update]

  def index
    registers = @model.order('created_at desc')
                    .by_month(params[:month])
                    .by_type(params[:type])
                    .by_article(params[:article_id])
                    .by_counterparty(params[:counterparty_id])
                    .by_date(params[:date])
                    .by_value(params[:value])
    if params[:offset]
      registers = registers.limit(10).offset(params[:offset].to_i)
    end
    json = ActiveModel::ArraySerializer.new(registers,
                                           each_serializer: RegisterSerializer,
                                           root: nil)
    render json: json, status: 200
  end

  def create
    register = @model.new(register_params)
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

  def set_model
    @model = Fact
  end

  def register_params
    params.require(:register).permit!
  end

  def find_register
    @register = @model.find params[:id]
  end

  def parse_month
    @month = params[:month].blank? ? Date.today : Date.parse(params[:month])
  end

end
