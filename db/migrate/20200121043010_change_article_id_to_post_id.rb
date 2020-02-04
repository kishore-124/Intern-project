class ChangeArticleIdToPostId < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :article_id, :post_id
  end
end
