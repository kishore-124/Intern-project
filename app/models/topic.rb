class Topic < ApplicationRecord
  #========================================== Relationships ====================
  has_many :posts, dependent: :destroy
  belongs_to :user
  #========================================== Validations ======================
  validates :title, presence: true, length: {maximum: 20}
end


