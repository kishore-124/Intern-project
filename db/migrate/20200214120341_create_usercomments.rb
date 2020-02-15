class CreateUsercomments < ActiveRecord::Migration[5.2]
  def change
    create_table :usercomments do |t|
      t.integer :star

      t.timestamps
    end
  end
end
