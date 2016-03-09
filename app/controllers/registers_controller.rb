class RegistersController < ApplicationController
  before_action :parse_month, only: :destroy
  before_action :find_register, only: [:destroy, :update, :show]
  before_action :set_model

  def index
    registers = @model.order('date desc')
                      .by_month(params[:month])
                      .by_type(params[:type])
                      .by_article(params[:article_id])
                      .by_counterparty(params[:counterparty_id])
                      .by_date(params[:date])
                      .by_value(params[:value])
                      .limit(10)
                      .offset(params[:offset] ? params[:offset].to_i : 0)
    json = ActiveModel::ArraySerializer.new(registers,
                                            each_serializer: RegisterSerializer,
                                            root: nil)
    render json: json, status: 200
  end

  def show
    render json: @register, status: :ok
  end

  def create
    register = @model.new(register_params)
    if register.save
      render json: RegisterSerializer.new(register), status: 200
    else
      render json: { status: :error, errors: register.errors.messages }, status: 422
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
      render json: { status: :error, error: @register.errors.messages, id: @register.id }, status: 422
    end
  end

  private

  def set_model
    @model = Fact
  end

  def register_params
    params.require(:register).permit(:date, :article_id, :counterparty_id, :value, :notes, :background, :currency)
  end

  def find_register
    set_model
    @register = @model.find params[:id]
  end

  def parse_month
    @month = params[:month].blank? ? Date.today : Date.parse(params[:month])
  end

  def count_profit(data)
    month_value = Array.new(12, 0)
    data.merge(data) do |month, objs|
      cost = objs.find { |obj| obj.type == 'Cost' }.try(:total)
      revenue = objs.find { |obj| obj.type == 'Revenue' }.try(:total)
      rate = cost && revenue ? (cost / revenue) * 100 : 0
      # HACK: to display chart by profit instead of cost
      month_value[month] = (100 - rate.round(2))
    end
    month_value.to_a
  end
end
