class PostsController < ApplicationController
  before_action :load_topic, only: [:show, :edit, :update, :destroy, :create, :index]
  before_action :load_post, only: [:show, :edit, :update, :destroy]
  def index
    @posts = @topic.posts.all
  end

  def edit
  end

  def show
  end

  def create
    @posts = @topic.posts.new(posts_params)
    @posts.save
      redirect_to topic_path(@topic)
  end

  def update
    if @posts.update(posts_params)
      redirect_to topic_posts_path(@topic)
    else
      render 'edit'
    end
  end

  def destroy
    @posts.destroy
    redirect_to topic_posts_path(@topic)
  end

  private
  def load_topic
    @topic = Topic.find(params[:topic_id])
  end

  def load_post
    @posts = @topic.posts.find(params[:id])
  end
  def posts_params
    params.require(:post).permit(:name, :description)
  end
end
