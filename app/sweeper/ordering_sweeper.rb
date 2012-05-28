class OrderingSweeper < ActionController::Caching::Sweeper
  observe Ordering # This sweeper is going to keep an eye on the Ordering model

  # If our sweeper detects that a Ordering was created call this
  def after_create(ordering)
    expire_cache_for(ordering)
  end

  # If our sweeper detects that a Ordering was updated call this
  def after_update(ordering)
    expire_cache_for(ordering)
  end

  # If our sweeper detects that a Ordering was deleted call this
  def after_destroy(ordering)
    expire_cache_for(ordering)
  end

  private
  def expire_cache_for(ordering)
    # Expire a fragment
    article = ordering.article
    expire_fragment('home_cat#'+article.issue_id.to_s+"-"+article.category_id.to_s) unless article.issue_id.nil?
    expire_fragment('home_issue#'+article.issue_id.to_s) unless (article.issue_id.nil? or article.ordering.issue_pos.nil?)
  end
end
