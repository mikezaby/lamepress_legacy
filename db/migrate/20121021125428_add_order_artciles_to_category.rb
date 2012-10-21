class AddOrderArtcilesToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :order_articles, :integer
  end
end
