class AddColumnUserIdToUsercomments < ActiveRecord::Migration[5.2]
  def change
    add_column :usercomments, :user_id, :integer
    add_column :usercomments, :comment_id, :integer
  end
end
