class Ordering < ActiveRecord::Base
  belongs_to :article, touch: true

  delegate :title, :issue_id, to: :article, prefix: true

  scope :issue, -> { where('issue_pos IS NOT NULL').order("issue_pos") }
  scope :category, -> { order("cat_pos") }
end
