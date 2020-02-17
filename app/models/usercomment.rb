class Usercomment < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  validates :user_id, uniqueness: true
end
