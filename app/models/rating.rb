class Rating < ApplicationRecord
  #========================================== Relationships ====================
  belongs_to :post
  #========================================== Callbacks ========================
  after_save :update_post_average_rating
  def update_post_average_rating
    post.update_attributes(average_rating: post.ratings.average(:star))
  end
end
