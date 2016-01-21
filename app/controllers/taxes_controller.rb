class TaxesController < ApplicationController
  before_action :find_tax
  before_action :check_user

  def edit
    render json: @tax.to_json(only: [:social, :single, :cash])
  end

  def update
    @tax.assign_attributes(tax_params)
    if @tax.save
      render json: {success: :ok}, status: 200
    else
      render json: {error: :error}, status: 422
    end
  end

  private

  def find_tax
    @tax = Tax.first
  end

  def tax_params
    params.require(:tax).permit(:social, :single, :cash)
  end

  def check_user
    render json: {error: 'Not authorization'} and return unless current_user
  end
end
