class CounterpartiesController < ApplicationController
  def index
    render json: Counterparty.all, status: 200
  end
end
