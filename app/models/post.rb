class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings
  has_one_attached :avatar
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy
  belongs_to :topic
  accepts_nested_attributes_for :tags, reject_if: :reject_tags
  validates :name, presence: true
  def reject_tags(attributes)
    attributes['name'].blank?
  end
end
