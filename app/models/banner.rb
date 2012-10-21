class Banner < ActiveRecord::Base

  belongs_to :block

  has_attached_file :photo,
                    :url  => "/media/banner/:id/:style_:filename",
                    :path => ":rails_root/public/media/banner/:id/:style_:filename",
                    :styles => {:thumb => "350>" },
                    :convert_options => { :thumb => '-quality 75' }

  validates :block_id, :presence => true
  validates_attachment :photo, :presence => true,
    :content_type => { :content_type => ['image/jpeg', 'image/png', 'image/gif'] }

  attr_accessible :describe, :block_id, :photo, :url

  delegate :name, :placement, :to => :block, :prefix => true

  def self.get_banner(block_id)
    where("block_id = ?", block_id).order("position ASC")
  end


  def path
    self.url.present? ? self.url : self.photo.url
  end

end

