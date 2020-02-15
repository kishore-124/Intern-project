class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :users , join_table: :posts_users_read_status
  has_many :ratings, dependent: :destroy
  has_one_attached :avatar
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy
  belongs_to :topic
  accepts_nested_attributes_for :tags, reject_if: :reject_tags
  validates :name, presence: true,length: { maximum: 20 }
  validate :avatar_image
  def avatar_image
    if avatar.attached? == false
      errors.add(:avatar,"can't be blank")
    elsif avatar.byte_size > 2_000_000.bytes
      avatar.purge
      errors.add(:avatar,'should be less than 2 mb')
    end
  end
  def reject_tags(attributes)
    attributes['name'].blank?
  end
end
