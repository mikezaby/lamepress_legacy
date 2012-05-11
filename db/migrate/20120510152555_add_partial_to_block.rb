class AddPartialToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :partial, :string
  end
end
