class Postsusersreadstatus < ActiveRecord::Migration[5.2]
  def change
    create_table :posts_users_read_status, :id => false do |t|
      t.integer :post_id
      t.integer :user_id
    end
  end
end
