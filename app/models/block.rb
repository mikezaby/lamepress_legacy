class Block < ActiveRecord::Base
  has_many :navigators
  #has_many :navigators, :as => :navigatable
  has_many :banners, :dependent => :destroy

  attr_accessible :name, :placement, :mode, :position


  def self.place(place)
		where('placement = ?', place).order('position')
	end

end

