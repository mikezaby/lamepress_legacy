class AddPositionToBanner < ActiveRecord::Migration
  def change
    add_column :banners, :position, :integer
  end
end
