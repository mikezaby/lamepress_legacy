class RemoveTagsFromArticle < ActiveRecord::Migration
  def self.up
    remove_column :articles, :tags
  end

  def self.down
    add_column :articles, :tags, :string
  end
end
