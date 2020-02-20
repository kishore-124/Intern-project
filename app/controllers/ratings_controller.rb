# frozen_string_literal: true

# RatingsController
class RatingsController < ApplicationController
  before_action :load_post, only: %i[create]

  def create
    @ratings = @posts.ratings.new(rating_params)
    @ratings.save
    flash[:notice] = 'Ratings added successfully'
    redirect_to topic_post_path(@posts.topic_id, @posts)
  end

  private

  def load_post
    @posts = Post.find(params[:post_id])
  end

  def rating_params
    params.require(:rating).permit(:star)
  end
end
