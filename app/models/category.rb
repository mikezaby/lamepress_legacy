class Category < ActiveRecord::Base

  include ActionView::Helpers::TextHelper

  ORDER_ARTICLES = { desc: 0, asc: 1 }

  has_many :articles
  has_many :navigators, as: :navigatable, dependent: :destroy

  validates :name, presence: true
  validates :permalink, uniqueness: true

  before_save :prettify_permalink

  attr_accessible :name, :permalink, :issued, :order_articles, :mode

  scope :issued, ->(value = true) { where(issued: value) }
  scope :non_issued, ->  { where(issued: false) }

  def ordered
    ORDER_ARTICLES.keys[order_articles]
  end

  private

  def prettify_permalink
    self.permalink = truncate(name.lm_strip, length: 50, separator: "-", omission: "")
  end
end
