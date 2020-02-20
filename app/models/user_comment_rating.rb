class UserCommentRating < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  validates :comment_id, uniqueness: true
end
