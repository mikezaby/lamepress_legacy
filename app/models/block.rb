class Block < ActiveRecord::Base
  has_many :navigators, :dependent => :destroy
  has_many :banners, :dependent => :destroy

  attr_accessible :name, :placement, :mode, :position, :partial

  scope :place, ->(place) { where(placement: place).order(:position) }
end
