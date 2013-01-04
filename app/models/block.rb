class Block < ActiveRecord::Base
  has_many :navigators, :dependent => :destroy
  has_many :banners, :dependent => :destroy

  attr_accessible :name, :placement, :mode, :position, :partial

  scope :get_mode, lambda { |mode| where(mode: mode) }
  scope :place, lambda { |place| where(placement: place).order(:position) }
end
