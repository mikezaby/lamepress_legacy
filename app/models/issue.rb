class Issue < ActiveRecord::Base
  has_many :articles, :dependent => :destroy

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

end

