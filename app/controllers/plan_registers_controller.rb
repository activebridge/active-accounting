class PlanRegistersController < RegistersController
  def index
    if params[:month]
      registers = Plan.order('created_at desc')
                          .by_month(parse_month)
                          .by_type(params[:type])
                          .by_article(params[:article_id])
    else
      registers = Plan.by_article(params[:article_id])
                          .by_counterparty(params[:counterparty_id])
                          .by_date(params[:date])
                          .by_value(params[:value])
    end
    json = ActiveModel::ArraySerializer.new(registers,
                                           each_serializer: RegisterSerializer,
                                           root: nil)
    render json: json, status: 200
  end

  def create
    register = Plan.new(register_params)
    if register.save
      render json: RegisterSerializer.new(register), status: 200
    else
      render json: {status: :error, errors: register.errors.messages}, status: 422
    end
  end

  private

  def register_params
    params[:plan_register].delete(:errors)
    params.require(:plan_register).permit!
  end

end
