class PostsController < ApplicationController
  before_action :load_topic, only: %i[show edit update create destroy]
  before_action :load_post, only: %i[show edit update]

  def index
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @pagy, @posts = pagy(@topic.posts.all, items: 10)
    else
      @pagy, @posts = pagy(Post.eager_load(:topic).all, items: 10)
    end
  end

  def edit
    @tags = Tag.all
  end

  def show
    @comment = Comment.new
    @tags = @posts.tags
    @rating = Rating.new
    @ratings = @posts.ratings.group(:ratings).count
  end

  def create
    @tags = Tag.all
    @posts = @topic.posts.new(posts_params)
    if  @posts.save
    redirect_to topic_path(@topic)
    flash[:notice] = 'Posts was successfully created'
    else
      render  "topics/show"
      end
  end

  def update
    @tags = Tag.all
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
    @posts.destroy
    format.html { redirect_to topic_posts_path(@topic), notice: 'Posts was successfully destroyed.'}
  rescue ActiveRecord::RecordNotFound
    format.html{  redirect_to topic_posts_path(@topic), notice: 'Record not found.'}
    end
  end

  private

  def load_topic
    @topic = Topic.find(params[:topic_id])
  end

  def load_post
    @posts = @topic.posts.find(params[:id])
  end

  def posts_params
    params.require(:post).permit(:name, :description,:avatar, tag_ids: [],tags_attributes: [:id, :name])
  end
end
