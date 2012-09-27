class Ordering < ActiveRecord::Base
  belongs_to :article
  scope :exist , where('issue_pos IS NOT NULL')
  scope :issue, exist.order("issue_pos")
  scope :category, order("cat_pos")

  delegate :title, :issue_id, :to => :article, :prefix => true
end

