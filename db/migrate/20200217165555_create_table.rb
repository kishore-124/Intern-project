class CreateTable < ActiveRecord::Migration[5.2]
  def change
    create_table :user_comment_rating do |t|
      t.integer :star

      t.timestamps
    end
  end
end
