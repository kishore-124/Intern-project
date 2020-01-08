class CommentsController < ApplicationController
  before_action :load_article, only: [:show, :edit, :update, :destroy, :create]
  before_action :load_comment, only: [:show, :edit, :update, :destroy]

  def create
    @comment = @article.comments.new(comment_params)
    @comment.save
    redirect_to article_path(@article)
  end

  def destroy
    @comment.destroy
    redirect_to article_path(@article)
  end

  def edit
  end

  def show
  end

  def update

    @comment.update(comment_params)
    redirect_to @article
  end

  private

  def load_article
    @article = Article.find(params[:article_id])
  end

  def load_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
