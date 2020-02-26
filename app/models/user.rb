class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,:async
  has_many :posts
  has_many :topics
  has_many :user_comment_ratings
  has_many :comments, :through => :user_comment_ratings
  has_and_belongs_to_many :posts, join_table: :posts_users_read_status
end
