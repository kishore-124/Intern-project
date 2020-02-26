class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :title, presence: true, length: {maximum: 20}
  belongs_to :user
end


