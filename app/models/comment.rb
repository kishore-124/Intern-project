class Comment < ApplicationRecord
  self.ignored_columns = ["user"]
  belongs_to :post,counter_cache: true
  validates :comment, presence: true
  has_many :usercomments
  has_many :users, :through => :usercomments
  belongs_to :user

end
