class AddTopicToPost < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :posts, :topic, foreign_key: true, index: {algorithm: :concurrently}

  end

end
