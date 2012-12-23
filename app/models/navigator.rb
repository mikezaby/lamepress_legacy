class Navigator < ActiveRecord::Base
  belongs_to :navigatable, :polymorphic => true
  belongs_to :block

  validates_presence_of :name, :block_id, :navigatable_id, :navigatable_type

  after_save :expire_cache

  def self.list(block_id)
    includes(:navigatable).where(block_id: block_id).order("position")
  end

  scope :orderit, order("block_id, position")
end

