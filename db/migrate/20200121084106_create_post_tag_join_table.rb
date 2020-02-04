class CreatePostTagJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :posts, :tags
  end
end
