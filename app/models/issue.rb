class Issue < ActiveRecord::Base
	has_many :articles, :dependent => :destroy

  after_save :expire_cache

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

  def self.last_created(number)
    order("created_at DESC").limit(number)
  end

  def self.search_issues(year,month,published)
    date1=year.to_s+"-"+month.to_s+"-00"
    date2=year.to_s+"-"+month.to_s+"-31"
    if published
      where("date > ? and date < ?", date1, date2).pub.order("date DESC")
    else
      where("date > ? and date < ?", date1, date2).order("date DESC")
    end
  end

  scope :pub , where("issues.published = TRUE")
	scope :unpub , where("issues.published = FALSE")

  private
  def expire_cache
    if self.number_changed?
      self.articles.each do |article|
        ActionController::Base.new.expire_fragment('article#'+article.id.to_s)
        ActionController::Base.new.expire_fragment('article-head#'+article.id.to_s)
      end
      Category.issued.each do |category|
        ActionController::Base.new.expire_fragment('home_cat#'+self.id.to_s+"-"+category.id.to_s)
        ActionController::Base.new.expire_fragment('home_cat-head#'+self.id.to_s+"-"+category.id.to_s)
        expire_fragment("feed##{category.id}")
      end
    end
    ActionController::Base.new.expire_fragment('home_issue#'+self.id.to_s)
    ActionController::Base.new.expire_fragment('home_issue-head#'+self.id.to_s)
    ActionController::Base.new.expire_fragment('cover#'+self.id.to_s)
  end

end

