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

  def self.search_issues(year,month, published = true)
    date = Date.new(year.to_i, month.to_i)
    start_date = date.beginning_of_month
    end_date =  date.end_of_month

    scope = where("date > ? and date <= ?", start_date, end_date).order("date DESC")
    scope = scope.published_only if published

    scope
  end

  scope :published_only , where(published: true)
  scope :unpublished_only , where(published: false)
end
