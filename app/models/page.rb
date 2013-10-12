class Page < ActiveRecord::Base

  include ActionView::Helpers::TextHelper

  has_many :navigators, as: :navigatable, dependent: :destroy

  validates :name, length: { maximum: 250 }
  validates :permalink, uniqueness: true, length: { maximum: 99 }
  validates :title, length: { maximum: 250 }
  validates :meta_description, length: { maximum: 250, allow_blank: true }

  before_validation :prettify_permalink

  attr_accessor :preview

  scope :published_only, -> { where(published: true) }

  private

  def prettify_permalink
    # parameterize function is nice but not as good as below
    self.permalink = truncate(self.permalink.strip.gsub(/[\~]|[\`]|[\!]|[\@]|[\#]|[\$]|[\%]|[\^]|[\&]|[\*]|[\(]|[\)]|[\+]|[\=]|[\{]|[\[]|[\}]|[\]]|[\|]|[\\]|[\:]|[\;]|[\"]|[\']|[\<]|[\,]|[\>]|[\.]|[\?]|[\/]/,"").gsub(/\s+/,"-").downcase, length: 100, separator: "-", omission: "")
  end
end
