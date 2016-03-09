class CounterpartiesController < ApplicationController
  before_action :find_conterparty, only: [:destroy, :update, :show]
  before_filter :authenticate_admin!, except: [:update, :customers]

  def index
    json = ActiveModel::ArraySerializer.new(Counterparty.by_group(params[:group]).by_active(params[:scope]),
                                            each_serializer: CounterpartySerializer,
                                            root: nil)
    render json: json, status: 200
  end

  def show
    render json: @counterparty, serializer: CounterpartySerializer, status: :ok
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
      if @counterparty.previous_changes.include?('value_payment')
        @counterparty.payment_histories.create(
          admin_id: current_admin.id,
          value_payment: @counterparty.value_payment
        )
      end
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
    params.require(:counterparty).permit(:id, :name, :start_date, :active, :value_payment, :monthly_payment, :type, :customer_id,
      :email, :password, :auth_token, :password_reset_token, :password_reset_sent_at, :approve_hours, :signed_in, :currency_monthly_payment)
  end

  def find_conterparty
    @counterparty = Counterparty.find(params[:id])
  end
end
