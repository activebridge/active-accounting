class CounterpartiesController < ApplicationController
  before_action :find_conterparty, only: [:destroy, :update]

  def index
    render json: Counterparty.all, status: 200
  end

  def create
    counterparty = Counterparty.new(counterparty_params)
    if counterparty.save
      render json: counterparty, status: 200
    else
      render json: {status: :error, error: counterparty.errors.messages}, status: 422
    end
  end

  def destroy
    @counterparty.destroy
    head(200)
  end


  def update
    if @counterparty.update_attributes(counterparty_params)
      render json: @counterparty, status: 201
    else
      render json: {status: :error, error: @counterparty.errors.messages}, status: 422
    end
  end

  private

  def counterparty_params
    params.require(:counterparty).permit(:name)
  end

  def find_conterparty
    @counterparty = Counterparty.find(params[:id])
  end
end
