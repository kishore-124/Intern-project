class Tag < ApplicationRecord
  #========================================== Relationships ====================
  has_and_belongs_to_many :posts
  #========================================== Validation =======================
  validates :name, presence: true
end
