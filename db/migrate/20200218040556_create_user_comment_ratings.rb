class CreateUserCommentRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_comment_ratings do |t|

      t.timestamps
    end
  end
end
