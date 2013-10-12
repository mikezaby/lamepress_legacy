class Article < ActiveRecord::Base

  # for using 'truncate' method on prettify_permalink
  include ActionView::Helpers::TextHelper

  after_save :assign_tags

  attr_writer :tag_names,:tag_links
  attr_accessor :preview

  belongs_to :category, touch: true
  belongs_to :issue, touch: true

  has_one :ordering, :dependent => :delete

  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings


  validates :title, :presence => true
  validates :date, :presence => true
  validates :html, :presence => true
  validates :category_id, :presence => true

  attr_accessible :tag_names, :title, :html, :author, :category_id, :issue_id,
                  :date, :published, :hypertitle, :photo, :preview

  delegate :number, :date, to: :issue, prefix: true
  delegate :name, :permalink, :issued, :to => :category, :prefix => true

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

  def self.home
    includes(:category, :tags).order_issue.published_only
  end

  def self.feed(id)
    includes(:issue, :category).where(category_id: id, published: true).
      select("title, categories.id, categories.name, categories.permalink,
              categories.issued, issues.number, author, id, html, created_at").
      order("articles.date DESC").limit(20)
  end

  scope :published_only, -> { where(published: true) }

  scope :order_issue, -> { joins(:ordering).merge(Ordering.issue) }
  scope :order_category, -> { joins(:ordering).merge(Ordering.category) }

  scope :issued, -> { where("issue_id is not NULL") }
  scope :non_issued, -> { where(issue_id: nil) }

  scope :for_category, ->(category_id) { use_index("index_articles_on_issue_id_and_category_id_and_published").
                                              includes(:category).
                                              where(category_id: category_id ) }

  def permalink
    # parameterize function is nice but not as good as below
    truncate(self.title.lm_strip, length: 50, separator: "-", omission: "")
  end

  alias :prettify_permalink :permalink

  private

  def self.use_index(index)
    from("#{self.table_name} USE INDEX(#{index})")
  end

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/,\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
