class SignaturesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    render json: Signature.all.as_json(methods: [:short_name_ua, :assigned]), status: :ok
  end

  def create
    signature = Signature.new(signature_params)
    if signature.save
      render json: signature, status: :created
    else
      render json: { error: signature.errors }, status: :unprocessable_entity
    end
  end

  def update
    if signature.update(signature_params)
      render json: signature, status: :ok
    else
      render json: { error: signature.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    signature.destroy unless signature.assigned?
    head(200)
  end

  private

  def signature_params
    params.require(:signature).permit(:name_ua, :name_en, :title_ua, :title_en, :tel, :email)
  end

  def signature
    @signature ||= Signature.find(params[:id])
  end
end
