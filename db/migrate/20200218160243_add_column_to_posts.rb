class AddColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :user_id, :integer
    add_column :posts, :comments_count, :integer
    add_column :posts, :average_rating, :float
  end
end
