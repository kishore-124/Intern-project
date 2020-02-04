class Comment < ApplicationRecord
  belongs_to :post
  validates :user, presence: true
end
