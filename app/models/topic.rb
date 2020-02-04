class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :title, presence: true
end

# def title_presence
# if title.blank?
# errors.add(:Title, "can't be blank")
# end
# end
# end