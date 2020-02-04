class Rating < ApplicationRecord
  belongs_to :post
  validates :ratings, presence: true
end
