class Linker < ActiveRecord::Base

	belongs_to :linkerable, :polymorphic => true

	validates :permalink, :uniqueness => true

	attr_accessible :permalink, :linkerable_id, :linkerable_type


end

