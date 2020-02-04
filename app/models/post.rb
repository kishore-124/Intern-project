class Post < ApplicationRecord
  has_many :ratings
  has_one_attached :avatar
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy
  belongs_to :topic
     accepts_nested_attributes_for :tags
  validates :name, presence: true
end
