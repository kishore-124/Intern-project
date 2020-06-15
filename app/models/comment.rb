class Comment < ApplicationRecord
  #========================================== Relationships ====================
  belongs_to :post, counter_cache: true
  has_many :user_comment_ratings
  has_many :comment_review, :through => :user_comment_ratings, :class_name => 'User'
  belongs_to :user
  #========================================== Validations ====================
  validates :comment, presence: true
end
