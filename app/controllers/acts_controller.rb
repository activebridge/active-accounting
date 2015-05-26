class ActsController < ApplicationController
  before_action :find_customer

  def show
    if invoice_calculator.hours_by_month.empty?
      render json: { hours: :empty  }, status: 422
    else
      @total_by_hours = invoice_calculator.total_money
      @act_date = params[:month].to_date
      respond_to do |format|
        format.html { render 'acts/show.pdf.erb' }
        format.pdf do
          render pdf: "act_#{@customer.name + Time.current.strftime('%m-%d-%Y')}",
                 template: 'acts/show.pdf.erb',
                 dpi: '1200'
        end
      end
    end
  end

  private

  def find_customer
    @customer = Customer.find(params[:id])
  end

  def invoice_calculator
    @invoice_calculator ||= InvoiceCalculator.new(@customer, params[:month])
  end
end
