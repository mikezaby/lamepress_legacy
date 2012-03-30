class Issue < ActiveRecord::Base
	has_many :articles, :dependent => :destroy
	has_one :current_issue
	has_one :linker, :as => :linkerable, :dependent => :destroy

	has_attached_file :cover,
										:url  => "/media/issues/:id/:style_issue_:id.:extension",
                  	:path => ":rails_root/public/media/issues/:id/:style_issue_:id.:extension",
                  	:styles => {:thumb => "212x290#" },
                  	:convert_options => { :thumb => '-quality 75' }
	has_attached_file :pdf,
										:url  => "/media/issues/:id/issue_:id.:extension",
                  	:path => ":rails_root/public/media/issues/:id/issue_:id.:extension"

	validates :number, :presence => true,  :uniqueness => true
	validates :date, :presence => true
	validates_attachment_content_type :cover, :content_type => ['image/jpeg', 'image/png', 'image/gif']
	validates_attachment_content_type :pdf, :content_type => ['application/pdf']

	attr_accessible :number, :date, :cover, :pdf, :published

	def self.get_issue(number)
    where("number = ?", number).pub
  end

  def self.last_issues(number)
    order("number DESC").pub.limit(number)
  end

  def self.search_issues(year,month)
    date1=year.to_s+"-"+month.to_s+"-00"
    date2=year.to_s+"-"+month.to_s+"-31"
    where("date > ? and date < ?", date1, date2).pub.order("date DESC")
  end

  scope :pub , where("issues.published = TRUE")
	scope :unpub , where("issues.published = FALSE")


end

