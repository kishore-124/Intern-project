class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # ,:lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :posts
  has_many :comments,  :through => :usercomments
  has_many :usercomments
  has_and_belongs_to_many :posts , join_table: :posts_users_read_status


end
