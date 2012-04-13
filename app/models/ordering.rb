class Ordering < ActiveRecord::Base
	belongs_to :article
	scope :exist , where("issue_pos != ?",'NULL')
	scope :issue_ordered, exist.order("issue_pos")
	scope :cat_ordered, order("cat_pos")

  delegate :title, :issue_id, :to => :article, :prefix => true
end

