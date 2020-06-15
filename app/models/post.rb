class Post < ApplicationRecord
  #========================================== Scope ============================
  scope :date_filter, lambda { |star_date, end_date|
    where('DATE(created_at) >= ? AND DATE(created_at) <= ?',
          star_date,
          end_date)
  }
  #========================================== Relationships ====================
  belongs_to :user
  has_and_belongs_to_many :post_reader, class_name: 'User', join_table: :posts_users_read_status
  has_many :ratings, dependent: :destroy
  has_one_attached :avatar
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy
  belongs_to :topic
  #========================================== Nested Attributes ================
  accepts_nested_attributes_for :tags, reject_if: :reject_tags
  #========================================== Validations ======================
  validates :name, presence: true, length: {maximum: 20}
  validate :avatar_image
  #========================================== Methods ==========================
  def avatar_image
    errors.add(:avatar, "can't be blank") unless avatar.attached?
    if avatar.attached?
      if avatar.byte_size > 2_000_000.bytes
        errors.add(:avatar, 'should be less than 2 mb')
      end
    end
  end

  def reject_tags(attributes)
    attributes['name'].blank?
  end
end
