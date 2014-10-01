class ArticlesController < ApplicationController
  before_action :find_article, only: [:destroy, :update]

  def index
    json = ActiveModel::ArraySerializer.new(Article.all,
                                           each_serializer: ArticleSerializer,
                                           root: nil)
    render json: json, status: 200
  end

  def create
    article = Article.new(article_params)
    if article.save
      render json: ArticleSerializer.new(article), status: 200
    else
      render json: {status: :error, error: article.errors.messages}, status: 422
    end
  end

  def destroy
    @article.destroy
    head(200)
  end


  def update
    if @article.update_attributes(article_params)
      render json: ArticleSerializer.new(@article), status: 201
    else
      render json: {status: :error, error: @article.errors.messages}, status: 422
    end
  end

  private

  def article_params
    params.require(:article).permit(:name, :type)
  end

  def find_article
    @article = Article.find(params[:id])
  end
end
