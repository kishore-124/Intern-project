class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

end
