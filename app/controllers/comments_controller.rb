class CommentsController < ApplicationController
  http_basic_authenticate_with name: "kishore", password: "kishore", only: :destroy
  before_action :load_comment, only: [:show, :edit, :update, :destroy, :create]
  def create
     @comment = @article.comments.new(comment_params)
     if @comment.save
      flash[:notice] = "Article successfully commented"
      redirect_to article_path(@article)
     else
       flash[:errors] = @comment.errors.full_messages
       redirect_to article_path(@article)
     end
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
      flash[:notice] = "Article comment successfully updated"
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
