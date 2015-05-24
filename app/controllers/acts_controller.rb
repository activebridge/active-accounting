class ActsController < ApplicationController
  before_action :data_for_act

  def show
    if hours_by_month.empty?
      render json: { hours: :empty  }, status: 422
    else
      respond_to do |format|
        format.html { render 'acts/show.pdf.erb' }
        format.pdf do
          render pdf: "act_#{@customer.name + Time.current.strftime('%m-%d-%Y')}",
                 template: 'acts/show.pdf.erb',
                 dpi: '600'
        end
      end
    end
  end

  private

  def data_for_act
    rate = customer.value_payment
    @total_by_hours = hours_by_month.sum(:hours) * rate
    @act_date = params[:month].to_date
    @customer = customer
  end

  def customer
    Customer.find(params[:id])
  end

  def hours_by_month
    Hour.by_customer(params[:id]).by_month(params[:month])
  end
end
