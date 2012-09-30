class Issue < ActiveRecord::Base
  has_many :articles, :dependent => :destroy

  after_save :expire_cache

  has_attached_file :cover,
                    :url  => "/media/issues/:id/:style_issue_:id.:extension",
                    :path => ":rails_root/public/media/issues/:id/:style_issue_:id.:extension",
                    :styles => {:thumb => "250>" },
                    :convert_options => { :thumb => '-quality 75' }
  has_attached_file :pdf,
                    :url  => "/media/issues/:id/issue_:id.:extension",
                    :path => ":rails_root/public/media/issues/:id/issue_:id.:extension"

  validates :number, :presence => true,  :uniqueness => true
  validates :date, :presence => true
  validates_attachment :cover, :presence => true,
    :content_type => { :content_type => ['image/jpeg', 'image/png', 'image/gif'] }
  validates_attachment :pdf, :presence => true,
    :content_type => { :content_type => ['application/pdf'] }

  attr_accessible :number, :date, :cover, :pdf, :published

  def self.get_public_issue(number)
    where(number: number).published_only
  end

  def self.last_issues(number)
    order("number DESC").published_only.limit(number)
  end

  def self.last_created(number)
    order("created_at DESC").limit(number)
  end

  def self.search_issues(year,month,published)
    date1=year.to_s+"-"+month.to_s+"-00"
    date2=year.to_s+"-"+month.to_s+"-31"
    if published
      where("date > ? and date < ?", date1, date2).published_only.order("date DESC")
    else
      where("date > ? and date < ?", date1, date2).order("date DESC")
    end
  end

  scope :published_only , where(published: true)
  scope :unpublished_only , where("issues.published = FALSE")

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

