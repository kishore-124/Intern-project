class User < ApplicationRecord
  #========================================== Devise Modules ===================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  #========================================== Relationships ====================
  has_many :posts
  has_many :topics
  has_many :user_comment_ratings
  has_many :comment_review, through: :user_comment_ratings, class_name: 'Comment'
  has_and_belongs_to_many :post_reader, class_name: 'Post', join_table: :posts_users_read_status
  #========================================== Callbacks ===================
  after_create :invite
  #========================================== Methods ====================
  def invite
    SendNewUserInvitationJob.perform_later(id)
  end
end
