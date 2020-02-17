class CommentsController < ApplicationController
  before_action :load_topic, only: %i[show edit update create user_comment_rating]
  before_action :load_post, only: %i[show edit update create user_comment_rating]
  before_action :load_comment, only: %i[show edit update user_comment_rating]
  load_and_authorize_resource only: %i[edit update show destroy]
  def create
    @ratings = @posts.ratings.group(:ratings).count
    @rating = Rating.new
    @tags = Tag.all
    @comment = @posts.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = 'comment was successfully created'
      redirect_to topic_post_path(@topic, @posts)
    else
      render 'posts/show'
      end
  end

  def destroy
    respond_to do |format|
      @topic = Topic.find(params[:topic_id])
      @posts = Post.find(params[:post_id])
      @comment = @posts.comments.find(params[:id])
      authorize! :destroy, @comment
      @comment.destroy
      format.html { redirect_to topic_post_path(@topic, @posts), notice: 'Comment was successfully destroyed'}
    rescue ActiveRecord::RecordNotFound
      format.html { redirect_to  topic_post_path(@topic, @posts), notice: 'Record not found.'}
    end
  end

  def edit; end

  def show
    @user_rating = Usercomment.new
    @tags = Tag.new
    @user_ratings=@comment.usercomments.all
  end

  def update
    authorize! :update, @comment
    @ratings = @posts.ratings.group(:ratings).count
    @tags = Tag.all
    if @comment.update(comment_params)
      flash[:notice] = 'comment was successfully updated'
      redirect_to topic_post_path(@topic, @posts)
    else
      render 'comments/edit'
    end

  end

  def user_comment_rating
    @user_rating = @comment.usercomments.new(load_user_comment)
    @user_rating.update(user_id: current_user.id)
    redirect_to topic_post_comment_path(@topic,@posts,@comment)
  end

  private

  def load_topic
    @topic = Topic.find(params[:topic_id])
  end

  def load_comment
    @comment = @posts.comments.find(params[:id] || params[:comment_id])
  end

  def load_post
    @posts = Post.find(params[:post_id])
  end

  def load_user_comment
    params.require(:usercomment).permit(:star)
  end

  def comment_params
    params.require(:comment).permit( :comment)
  end
end
