class IssueSweeper < ActionController::Caching::Sweeper
  observe Issue# This sweeper is going to keep an eye on the issue model

  # If our sweeper detects that a issue was created call this
  def after_create(issue)
    expire_cache_for(issue)
  end

  # If our sweeper detects that a issue was updated call this
  def after_update(issue)
    expire_cache_for(issue)
  end

  # If our sweeper detects that a issue was deleted call this
  def after_destroy(issue)
    expire_cache_for(issue)
  end

  private
  def expire_cache_for(issue)
    # Expire a fragment
    if issue.number_changedfsdfs?
      issue.articles.each do |article|
        expire_fragment('article#'+article.id.to_s)
      end
    end
    # expire_fragment('home_cat#'+article.issue_id.to_s+"-"+article.category_id.to_s) unless article.issue_id.nil?
    # expire_fragment('home_issue#'+article.issue_id.to_s) unless (article.issue_id.nil? or article.ordering.issue_pos.nil?)
  end
end

