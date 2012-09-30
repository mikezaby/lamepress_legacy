class Block < ActiveRecord::Base
  has_many :navigators, :dependent => :destroy
  #has_many :navigators, :as => :navigatable
  has_many :banners, :dependent => :destroy

  attr_accessible :name, :placement, :mode, :position, :partial

  scope :get_mode, lambda {|mode| where(mode: mode)}

  def self.place(place)
    where('placement = ?', place).order('position')
  end

  def self.get_name(id)
    find_by_id(id).name
  end
end

