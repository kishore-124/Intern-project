class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  validates :comment, presence: true
  has_many :user_comment_ratings
  has_many :users, :through => :user_comment_ratings
  belongs_to :user
end
