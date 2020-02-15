class RemoveColumnUserFromComments < ActiveRecord::Migration[5.2]
  def change
    safety_assured{ remove_column :comments, :user}
  end
end
