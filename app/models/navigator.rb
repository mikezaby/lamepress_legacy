class Navigator < ActiveRecord::Base
  belongs_to :navigatable, :polymorphic => true
  belongs_to :block

  validates_presence_of :name, :block_id, :navigatable_id, :navigatable_type

  after_save :expire_cache

  def self.list(block_id)
    where('block_id = ?', block_id).order("position")
  end

  scope :orderit, order("block_id, position")

  private
  def expire_cache
    ActionController::Base.new.expire_fragment('navigator#'+self.block_id.to_s)
    ActionController::Base.new.expire_fragment(%r{block_category##{self.block.id.to_s}-\d+})
    if self.block_id_changed?
      ActionController::Base.new.expire_fragment('navigator#'+self.block_id_was.to_s)
      ActionController::Base.new.expire_fragment(%r{block_category##{self.block_id_was.to_s}-\d+})
    end
  end


end

