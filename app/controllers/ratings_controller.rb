# frozen_string_literal: true

# RatingsController
class RatingsController < ApplicationController
  before_action :load_post, only: %i[create]

  def create
    @ratings = @post.ratings.new(rating_params)
    @ratings.save
    flash[:notice] = 'Ratings added successfully'
    redirect_to topic_post_path(@post.topic_id, @post)
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

  def rating_params
    params.require(:rating).permit(:star)
  end
end
