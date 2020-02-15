class RemoveColumnUserIdFromTopics < ActiveRecord::Migration[5.2]
  def change
    safety_assured{ remove_column :topics, :user_id}
  end
end
