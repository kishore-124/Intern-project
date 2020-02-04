class CreateTopicTagJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :topics, :tags
  end
end
