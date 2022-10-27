class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    puts "session[:page_views]"
    article = Article.find(params[:id])
    
    session[:page_views] ||= 0
    
    if session[:page_views] < 3
      render json: article
      session[:page_views] += 1
    else
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
      session[:page_views] += 1
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
