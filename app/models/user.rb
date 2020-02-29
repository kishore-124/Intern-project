class User < ApplicationRecord
  #========================================== Devise Modules ===================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  #========================================== Relationships ====================
  has_many :posts
  has_many :topics
  has_many :user_comment_ratings
  has_many :reviewers, through: :user_comment_ratings, class_name: 'Comment'
  has_and_belongs_to_many :readers, class_name: 'Post', join_table: :posts_users_read_status

  after_create :invite
  #========================================== Methods ====================
  def invite
    SendNewUserInvitationJob.perform_later(id)
  end
end
