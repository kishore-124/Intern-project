class CommentsController < ApplicationController
  before_action :load_topic, only: %i[show edit update create]
  before_action :load_post, only: %i[show edit update create]
  before_action :load_comment, only: %i[show edit update]

  def create
    @ratings = @posts.ratings.group(:ratings).count
    @tags=Tag.all
    @comment = @posts.comments.new(comment_params)
    if @comment.save
    flash[:notice]='comment was successfully created'
    redirect_to   topic_post_path(@topic, @posts)
    else
      render 'posts/show'
      end
  end

  def destroy
    respond_to do |format|
    @topic = Topic.find(params[:topic_id])
    @posts = Post.find(params[:post_id])
    @comment = @posts.comments.find(params[:id])
    @comment.destroy
    format.html{ redirect_to  topic_post_path(@topic, @posts),notice:'Comment was successfully destroyed'}
    rescue ActiveRecord::RecordNotFound
      format.html{ redirect_to  topic_post_path(@topic, @posts), notice: 'Record not found.'}
    end
  end

  def edit
  end

  def show
    @tags = Tag.new
  end

  def update
    @ratings = @posts.ratings.group(:ratings).count
    @tags=Tag.all
    if @comment.update(comment_params)
      flash[:notice]='comment was successfully updated'
      redirect_to topic_post_path(@topic, @posts)
    else
      render 'comments/edit'
    end

  end

  private

  def load_topic
     @topic = Topic.find(params[:topic_id])
  end

  def load_comment
     @comment = @posts.comments.find(params[:id])
  end
  def load_post
     @posts = Post.find(params[:post_id])
  end
  def comment_params
    params.require(:comment).permit(:user, :comment)
  end
end
