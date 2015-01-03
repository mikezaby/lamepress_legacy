class Ordering < ActiveRecord::Base
  belongs_to :article, touch: true

  delegate :title, :issue_id, to: :article, prefix: true

  scope :issue, -> { where('issue_pos IS NOT NULL').order("issue_pos") }
  scope :category, -> { order("cat_pos") }

  scope :for_issue, -> (issue) { where(articles: { issue_id: issue }) }
  scope :for_category, -> (category) { where(articles: { category_id: category }) }
  scope :without_issue_position, -> { where(issue_pos: nil) }
  scope :with_issue_position, -> { where.not(issue_pos: nil) }
end
