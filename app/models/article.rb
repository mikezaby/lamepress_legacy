class Article < ActiveRecord::Base

  include ActionView::Helpers::TextHelper # for using 'truncate' method on prettify_permalink

  after_save :assign_tags

  attr_writer :tag_names
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

  attr_accessible :tag_names, :title, :html, :author, :category_id, :issue_id, :date, :published, :hypertitle, :photo, :preview

	delegate :number, :date, :cover, :pdf, :published, :to => :issue, :prefix => true
	delegate :name, :permalink, :issued, :to => :category, :prefix => true
	delegate :issue_pos, :cat_pos, :to => :ordering, :prefix => true

  has_attached_file :photo,
										:url  => "/media/articles/:id/:style_img_:id.:extension",
                  	:path => ":rails_root/public/media/articles/:id/:style_img_:id.:extension",
                  	:styles => {:medium => "225>", :small => "200>" }

  UNRANSACKABLE_ATTRIBUTES = ["id", "updated_at", "created_at", "published"]

  def self.ransackable_attributes auth_object = nil
    (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
  end

  def tag_names
    @tag_names || tags.map(&:name).join(', ')
  end

	def self.cat_home(number, category)
		art_issue(number).art_cat(category).cat_order
	end

	def self.one_art(issue_id, category_id)
	  where(issue_id: issue_id, category_id: category_id)
	end


	def self.home(number)
		art_issue(number).iss_order
	end

	def self.art_cat(category)
  	where(published: true).joins(:category).merge(Category.get_cat(category))
  end

	def self.art_issue(number)
  	where(published: true).joins(:issue).merge(Issue.get_issue(number))
  end

  def self.last_arts(number)
    order("date DESC").first(number)
  end


	scope :iss_order, joins(:ordering).merge(Ordering.issue_ordered)
	scope :cat_order, joins(:ordering).merge(Ordering.cat_ordered)

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

