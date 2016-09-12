class RegistersController < ApplicationController
  before_action :parse_month, only: :destroy
  before_action :find_register, only: [:destroy, :update, :show]
  before_action :set_model

  def index
    registers = @model.index_sort(params.slice(:month, :type, :article_id, :counterparty_id, :vendor_id, :date, :value, :offset))
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
    params.require(:register).permit(:date, :article_id, :counterparty_id, :vendor_id, :value, :notes, :background, :currency)
  end

  def find_register
    set_model
    @register = @model.find params[:id]
  end

  def parse_month
    @month = params[:month].blank? ? Date.today : Date.parse(params[:month])
  end
end
