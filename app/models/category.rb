class Category < ActiveRecord::Base

	after_update :update_link

	has_many :articles
	has_many :navigators, :as => :navigatable

	has_one :linker, :as => :linkerable, :dependent => :destroy

	validates :name, :presence => true
	validates :permalink, :presence => true, :uniqueness => true

	attr_accessible :name, :permalink, :issued
  delegate :permalink, :to => :linker, :prefix => true

	def self.get_cat(category)
    where("categories.permalink = ?", category)
  end

  def update_link
    if !self.issued
      link = self.linker
		  url= "/"+self.permalink
		  if !link.nil?
        link.update_attributes(:permalink => url)
      else
        self.create_linker(:permalink => url)
      end
    end
  end

  scope :issued , where(:issued => true)
  scope :mobile_issued , where(:issued => true).select("id, name, permalink")
	scope :non_issued , where(:issued => false)

end

