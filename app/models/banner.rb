class Banner < ActiveRecord::Base

  belongs_to :block

  has_attached_file :photo,
										:url  => "/media/banner/:filename.:extension",
                  	:path => ":rails_root/public/media/banner/:filename.:extension"

  validates :block_id, :uniqueness => true, :presence => true
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  attr_accessible :describe, :block_id, :photo, :url

  delegate :name, :placement, :to => :block, :prefix => true

  def self.get_banner(blockid)
    where("block_id = ?", blockid)
  end

end

