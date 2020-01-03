class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "kishore", password: "kishore", except: [:index, :show]
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
  end
  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:notice] = "Article successfully created"
      redirect_to @article
    else
      flash[:errors] = @article.errors.full_messages
      render 'new'
    end
  end
  def update
    if @article.update(article_params)
      flash[:notice] = "Article successfully updated"
      redirect_to @article
    else
      flash[:errors] = @article.errors.full_messages
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
  private
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
