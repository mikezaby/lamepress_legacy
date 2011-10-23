class Navigator < ActiveRecord::Base
	belongs_to :navigatable, :polymorphic => true
  belongs_to :block

	def self.list(block_id)
		where('block_id = ?', block_id).order("position")
	end

	scope :orderit, order("block_id, position")




end

