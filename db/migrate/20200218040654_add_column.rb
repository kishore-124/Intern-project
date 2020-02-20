class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :user_comment_ratings, :star, :integer
    add_column :user_comment_ratings, :user_id, :integer
    add_column :user_comment_ratings, :comment_id, :integer
  end
end
