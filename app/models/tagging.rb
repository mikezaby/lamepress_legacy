class Tagging < ActiveRecord::Base
  belongs_to :article, touch: true
  belongs_to :tag, touch: true

  validates :tag_id, uniqueness: { scope: :article_id }
end
