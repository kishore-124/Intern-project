class CommentsController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy
  before_action :load_comment, only: [:show, :edit, :update, :destroy, :create]
  def create
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end
  def destroy
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end
  def edit
    @comment = @article.comments.find(params[:id])
  end
  def show
    @comment = @article.comments.find(params[:id])
  end
  def update
    @comment = @article.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to @article
    else
      flash[:errors] = @article.comments.errors.full_messages
      render 'edit'
    end
  end
  private
  def load_comment
    @article = Article.find(params[:article_id])
  end
  private
  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
