class PostsController < ApplicationController
  before_action :load_topic, only: %i[show edit update create destroy]
  before_action :load_post, only: %i[show edit update]
  load_and_authorize_resource :only => [:edit, :update,:show,:destroy]
  def index
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @pagy, @posts = pagy(@topic.posts.eager_load(:topic, :user).all, items: 10)
    else
      @pagy, @posts = pagy(Post.eager_load(:topic, :user).all, items: 10)
    end
  end
  def edit
    @tags = Tag.all
  end
  def show
    @user = User.all
    @comment = Comment.new
    @tags = @posts.tags
    @rating = Rating.new
    @ratings = @posts.ratings.group(:star).count
    @avg = @posts.ratings.average(:star).round(1) unless @posts.ratings.size < 1
  end
  def create
    respond_to do |format|
    @tags = Tag.all
    @posts = @topic.posts.new(posts_params)
    @posts.user_id = current_user.id
      format.html{ redirect_to topic_path(@topic),notice: 'Posts was successfully created.'}
      format.js
    end
  end

  def update
    @tags = Tag.all
    authorize! :update, @posts
    if @posts.update(posts_params)
      redirect_to topic_posts_path(@topic)
      flash[:notice] = 'Posts was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    respond_to do |format|
    @posts = @topic.posts.find(params[:id])
    authorize! :destroy, @posts
    @posts.destroy
    format.html { redirect_to topic_posts_path(@topic), notice: 'Posts was successfully destroyed.'}
    rescue ActiveRecord::RecordNotFound
    format.html{ redirect_to topic_posts_path(@topic), notice: 'Record not found.'}
    end
  end
  def readstatus
    @posts = Post.find(params[:id])
    unless  @posts.users.where(posts_users_read_status: {user_id:current_user.id,post_id: @posts.id}).present?
    @posts.users << current_user
    end
  end

  private

  def load_topic
    @topic = Topic.find(params[:topic_id])
  end
  def load_user
    @user = User.find(params[:user_id])
  end

  def load_post
    @posts = @topic.posts.find(params[:id])
  end

  def posts_params
    params.require(:post).permit(:name, :description, :avatar, tags_attributes: %i[id name], tag_ids: [] )
  end
end
