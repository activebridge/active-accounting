class TaxesController < ApplicationController
  skip_before_action :authenticate_admin!
  before_action :find_tax
  before_action :check_user, only: :update

  def edit
    render json: @tax.to_json(only: [:social, :single, :cash])
  end

  def update
    @tax.assign_attributes(tax_params)
    if @tax.save
      render json: {success: :accepted}, status: 202
    else
      render json: :unprocessable_entity, status: 422
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
    render json: {error: 'Not authorization'} and return unless current_admin
  end
end
