class ChangeArticleHtmlToMediumText < ActiveRecord::Migration
  def change
    change_column :articles, :html, :text, :limit => 16777215
  end
end
