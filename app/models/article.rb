class Article < ActiveRecord::Base

  # for using 'truncate' method on prettify_permalink
  include ActionView::Helpers::TextHelper

  after_save :assign_tags

  attr_writer :tag_names,:tag_links
  attr_accessor :preview

  belongs_to :category
  belongs_to :issue

  has_one :ordering, :dependent => :delete

  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings


  validates :title, :presence => true
  validates :date, :presence => true
  validates :html, :presence => true
  validates :category_id, :presence => true

  attr_accessible :tag_names, :title, :html, :author, :category_id, :issue_id,
                  :date, :published, :hypertitle, :photo, :preview

  delegate :number, :date, :cover, :pdf, :published, :to => :issue, :prefix => true
  delegate :name, :permalink, :issued, :to => :category, :prefix => true
  delegate :issue_pos, :cat_pos, :to => :ordering, :prefix => true

  has_attached_file :photo,
                    :url  => "/media/articles/:id/:style_img_:id.:extension",
                    :path => ":rails_root/public/media/articles/:id/:style_img_:id.:extension",
                    :styles => {:medium => "225>", :small => "200>" }

  UNRANSACKABLE_ATTRIBUTES = ["id", "updated_at", "created_at", "published"]

  def self.ransackable_attributes(auth_object = nil)
    if auth_object == 'admin'
      column_names + _ransackers.keys
    else
      (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
    end
  end

  def tag_names
    @tag_names || tags.map(&:name).join(', ')
  end

  def tag_links
    #todo
  end

  def self.home_issue(issue_number)
    includes(:category, :tags).public_issue(issue_number).order_issue.published_only
  end

  def self.issued_article(id, issue_number, category_perma)
    includes(:category, :tags).public_issue(issue_number).
      merge(Category.where(permalink: category_perma).issued).where(id: id).
      published_only.first
  end

  def self.issued_category(issue_number, category_perma)
    includes(:category, :tags).public_issue(issue_number).
      merge(Category.where(permalink: category_perma).issued).order_category.
      published_only
  end

  def self.not_issued_category(category_perma, page = 0)
    includes(:category, :tags).merge(Category.where(permalink: category_perma)).
      published_only.order('date DESC').page(page).per(10)
  end

  def self.not_issued_article(id, category_perma)
    includes(:category, :tags).merge(Category.where(permalink: category_perma)).
      where(id: id, issue_id: nil).published_only.first
  end

  def self.feed(id)
    includes(:issue, :category).where(category_id: id, published: true).
      select("title, categories.id, categories.name, categories.permalink,
              categories.issued, issues.number, author, id, html, created_at").
      order("articles.date DESC").limit(20)
  end

  def self.public_issue(issue_number)
    includes(:issue).merge(Issue.get_public_issue(issue_number))
  end

  def self.the_last(number)
    includes(:category).order('created_at DESC').limit(number)
  end

  scope :published_only, where(published: true)

  scope :order_issue, joins(:ordering).merge(Ordering.issue)
  scope :order_category, joins(:ordering).merge(Ordering.category)

  scope :issued , where("issue_id is not NULL").order('created_at DESC').includes(:issue, :category)
  scope :non_issued , where("issue_id is NULL").order('created_at DESC').includes(:issue, :category)

  def prettify_permalink
    # parameterize function is nice but not as good as below
    truncate(self.title.lm_strip, length: 50, separator: "-", omission: "")
  end

  private

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/,\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

end

