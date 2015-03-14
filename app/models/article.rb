class Article < ActiveRecord::Base

  include ActionView::Helpers::TextHelper

  UNRANSACKABLE_ATTRIBUTES = ["id", "updated_at", "created_at", "published"]

  belongs_to :category, touch: true
  belongs_to :issue, touch: true

  has_one :ordering, dependent: :delete

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_attached_file :photo,
                    url: "/media/articles/:id/:style_img_:id.:extension",
                    path: ":rails_root/public/media/articles/:id/:style_img_:id.:extension",
                    styles: { medium: "225>", small: "200>" }

  validates :title, presence: true
  validates :date, presence: true
  validates :html, presence: true
  validates :category_id, presence: true

  after_save :assign_tags

  delegate :number, :date, to: :issue, prefix: true
  delegate :name, :permalink, :issued, to: :category, prefix: true

  attr_writer :tag_names,:tag_links
  attr_accessor :preview

  attr_accessible :tag_names, :title, :html, :author, :category_id, :issue_id,
                  :date, :published, :hypertitle, :preview

  scope :published_only, -> { where(published: true) }

  scope :order_issue, -> { joins(:ordering).merge(Ordering.issue) }
  scope :order_category, -> { joins(:ordering).merge(Ordering.category) }

  scope :issued, -> { where("issue_id is not NULL") }
  scope :non_issued, -> { where(issue_id: nil) }

  scope :for_category, ->(category_id) { use_index("index_articles_on_issue_id_and_category_id_and_published").
                                           includes(:category).
                                           where(category_id: category_id ) }

  scope :home, -> { includes(:category, :tags).order_issue.published_only }

  def self.feed(id)
    includes(:issue, :category).where(category_id: id).published_only.
      select("title, categories.id, categories.name, categories.permalink,
              categories.issued, issues.number, author, id, html, created_at").
      order("articles.date DESC").limit(20)
  end

  def self.ransackable_attributes(auth_object = nil)
    available_attr = super
    available_attr -= UNRANSACKABLE_ATTRIBUTES if auth_object != 'admin'
    available_attr
  end

  def tag_names
    @tag_names || tags.map(&:name).join(', ')
  end

  def permalink
    truncate(self.title.lm_strip, length: 50, separator: "-", omission: "")
  end
  alias :prettify_permalink :permalink

  private

  def self.use_index(index)
    from("#{self.table_name} USE INDEX(#{index})")
  end

  def assign_tags
    return if @tag_names.blank?

    self.tags = @tag_names.split(/,\s+/).map do |name|
      Tag.where(name: name).first_or_create
    end
  end
end
