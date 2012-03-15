class Category < ActiveRecord::Base

  include ActionView::Helpers::TextHelper # for using 'truncate' method on prettify_permalink

	before_save :prettify_permalink
	after_save :update_linker

	has_many :articles
	has_many :navigators, :as => :navigatable

	has_one :linker, :as => :linkerable, :dependent => :destroy

	validates :name, :presence => true
	validates :permalink, :uniqueness => true

	attr_accessible :name, :permalink, :issued
  delegate :permalink, :to => :linker, :prefix => true

	def self.get_cat(category)
    where("categories.permalink = ?", category)
  end

  def prettify_permalink
    # parameterize function is nice but not as good as below
    self.permalink = self.name
    self.permalink = truncate(self.permalink.strip.gsub(/[\~]|[\`]|[\!]|[\@]|[\#]|[\$]|[\%]|[\^]|[\&]|[\*]|[\(]|[\)]|[\+]|[\=]|[\{]|[\[]|[\}]|[\]]|[\|]|[\\]|[\:]|[\;]|[\"]|[\']|[\<]|[\,]|[\>]|[\.]|[\?]|[\/]/,"").gsub(/\s+/,"-").downcase, length: 50, separator: "-", omission: "")
  end

  def update_linker
    if !self.issued
      linker = self.linker
		  url= "/"+self.permalink
		  if !linker.nil?
        linker.update_attributes(:permalink => url)
        #self.articles.each {|article| article.save} #big proccess
      else
        self.create_linker(:permalink => url)
      end
    end
  end

  scope :issued , where(:issued => true)
  scope :mobile_issued , where(:issued => true).select("id, name, permalink")
	scope :non_issued , where(:issued => false)

end

