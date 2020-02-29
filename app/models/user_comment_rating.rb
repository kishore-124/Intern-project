class UserCommentRating < ApplicationRecord
  #========================================== Relationships ====================
  belongs_to :user
  belongs_to :comment
end
