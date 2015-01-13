class PlanRegistersController < RegistersController
  before_action :set_model

  private

  def register_params
    params[:plan_register].delete(:errors)
    params.require(:plan_register).permit!
  end

  def set_model
    @model = Plan
  end

end
