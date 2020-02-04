class RatingsController < ApplicationController
  before_action :load_topic, only: %i[create]
  before_action :load_post, only: %i[create]
  def create
    if params[:rating]
    @ratings = @posts.ratings.new(rating_params)
    @ratings.save
    flash[:notice] = 'Ratings added successfully'
    redirect_to topic_post_path(@topic, @posts)
    else
      flash[:notice] = 'Please select one ratings'
      redirect_to topic_post_path(@topic, @posts)
    end
  end

  private

  def load_topic
    @topic = Topic.find(params[:topic_id])
  end

  def load_post
    @posts = @topic.posts.find(params[:post_id])
  end

  def rating_params
    params.require(:rating).permit(:ratings)
  end
end
