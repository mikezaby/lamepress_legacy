class Category < ActiveRecord::Base

  include ActionView::Helpers::TextHelper # for using 'truncate' method on prettify_permalink

  before_save :prettify_permalink

  has_many :articles
  has_many :navigators, :as => :navigatable, :dependent => :destroy


  validates :name, :presence => true
  validates :permalink, :uniqueness => true

  attr_accessible :name, :permalink, :issued


  def self.get_cat(category)
    where("categories.permalink = ?", category)
  end

  def prettify_permalink
    # parameterize function is nice but not as good as below
    self.permalink = self.name
    self.permalink = truncate(self.permalink.lm_strip, length: 50, separator: "-", omission: "")
  end


  scope :issued , where(:issued => true)
  scope :mobile_issued , where(:issued => true).select("id, name, permalink")
  scope :non_issued , where(:issued => false)

end

