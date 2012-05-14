class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article # This sweeper is going to keep an eye on the article model

  # If our sweeper detects that a article was created call this
  def after_create(article)
    expire_cache_for(article)
  end

  # If our sweeper detects that a article was updated call this
  def after_update(article)
    expire_cache_for(article)
  end

  # If our sweeper detects that a article was deleted call this
  def after_destroy(article)
    expire_cache_for(article)
  end

  private
  def expire_cache_for(article)
    # Expire a fragment
    expire_fragment('article#'+article.id.to_s)
    expire_fragment('article-head#'+article.id.to_s)
    expire_fragment('home_cat#'+article.issue_id.to_s+"-"+article.category_id.to_s) unless article.issue_id.nil?
    expire_fragment('home_issue#'+article.issue_id.to_s) unless (article.issue_id.nil? or article.ordering.issue_pos.nil?)
    expire_fragment('block_category#'+article.category.id.to_s)
    unless article.category.issued
      expire_fragment('category#'+article.category_id.to_s)
      expire_fragment(%r{category##{article.category.id.to_s}#page#\d+})
    end
  end
end

