class CounterpartiesController < ApplicationController
  before_action :find_conterparty, only: [:destroy, :update]
  before_filter :authenticate_user!, except: [:update, :customers]

  def index
    json = ActiveModel::ArraySerializer.new(Counterparty.by_group(params[:group]).by_active(params[:scope]),
                                            each_serializer: CounterpartySerializer,
                                            root: nil)
    render json: json, status: 200
  end

  def create
    counterparty = Counterparty.new(counterparty_params)
    if counterparty.save
      render json: CounterpartySerializer.new(counterparty), status: 200
    else
      render json: { status: :error, error: counterparty.errors.messages }, status: 422
    end
  end

  def destroy
    @counterparty.destroy unless @counterparty.assigned?
    head(200)
  end

  def update
    if @counterparty.update_attributes(counterparty_params)
      render json: CounterpartySerializer.new(@counterparty), status: 201
    else
      render json: { status: :error, error: @counterparty.errors.messages }, status: 422
    end
  end

  def payments
    type = params[:sandbox] ? Register::TYPES::PLAN : Register::TYPES::FACT
    counterparties = Counterparty.unpaid_for(Date.parse(params[:month]), type)
    json = ActiveModel::ArraySerializer.new(counterparties,
                                            each_serializer: CounterpartyRegisterSerializer,
                                            root: nil)
    render json: json, status: 200
  end

  def customers
    render json: Customer.by_active(params[:scope]), root: false
  end

  private

  def counterparty_params
    params.require(:counterparty).permit!
  end

  def find_conterparty
    @counterparty = Counterparty.find(params[:id])
  end
end
