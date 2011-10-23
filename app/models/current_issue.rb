class CurrentIssue < ActiveRecord::Base
	belongs_to :issue
	attr_accessible :issue_id

	delegate :number, :date, :cover, :pdf, :published, :to => :issue, :prefix => true
end
