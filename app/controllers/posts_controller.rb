# frozen_string_literal: true

# PostsController
class PostsController < ApplicationController
  before_action :load_topic, only: %i[show edit update create destroy]
  before_action :load_post, only: %i[show edit update destroy]
  before_action :load_tags, only: %i[create update edit]
  authorize_resource only: %i[edit update show destroy]


  def index
    @start_date = params[:start_date].blank? ? Date.yesterday : params[:start_date]
    @end_date = params[:end_date].blank? ? Date.today : params[:end_date]
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
     @posts = @topic.posts.date_filter(@start_date, @end_date).includes(:topic,:user).all
    else
      @posts = Post.date_filter(@start_date, @end_date).includes(:topic,:user).all
    end
    @pagy, @posts = pagy(@posts, items: 10)
  end

  def edit; end

  def show
    @comment = Comment.new
    @tags = @post.tags
    @ratings = @post.ratings.group(:star).count

  end

  def create
    respond_to do |format|
      @post = @topic.posts.new(posts_params)
      @post.user_id = current_user.id
      @post.save
      format.html { redirect_to topic_path(@topic), notice: 'Posts was successfully created.' }
      format.js
    end
  end

  def update
    if @post.update(posts_params)
      redirect_to topic_posts_path(@topic)
      flash[:notice] = 'Posts was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to topic_posts_path(@topic)
    flash[:notice] = 'Posts was successfully destroyed.'
  end

  def read_status
    @post = Post.find(params[:id])
    unless @post.post_reader.where(posts_users_read_status: {user_id: current_user.id, post_id: @post.id}).present?
      @post.post_reader << current_user
    end
  end

  private

  def load_topic
    @topic = Topic.find(params[:topic_id])
  end

  def load_tags
    @tags = Tag.all
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_post
    @post = @topic.posts.find(params[:id])
  end

  def posts_params
    params.require(:post).permit(:name, :description, :avatar, tags_attributes: %i[id name], tag_ids: [])
  end



end
