class Block < ActiveRecord::Base
  has_many :navigators, dependent: :destroy
  has_many :banners, dependent: :destroy

  scope :place, ->(place) { where(placement: place).order(:position) }
end
