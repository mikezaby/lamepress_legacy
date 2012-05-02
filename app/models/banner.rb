class Banner < ActiveRecord::Base

  belongs_to :block

  before_save :check_url

  has_attached_file :photo,
										:url  => "/media/banner/:filename.:extension",
                  	:path => ":rails_root/public/media/banner/:filename.:extension"

  validates :block_id, :presence => true
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  attr_accessible :describe, :block_id, :photo, :url

  delegate :name, :placement, :to => :block, :prefix => true

  def self.get_banner(blockid)
    where("block_id = ?", blockid)
  end


  private
  
  def check_url
    if self.url.nil? or self.url == ""
      self.url = self.photo.url
    end
  end

end

