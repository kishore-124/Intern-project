class ArticlesController < ApplicationController
  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def new
    @article = Article.new
  end

  def index
    @articles = Article.all
  end

  def edit
  end

  def show
    @comment = Comment.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def load_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
