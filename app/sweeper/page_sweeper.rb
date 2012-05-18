class PageSweeper < ActionController::Caching::Sweeper
  observe Page # This sweeper is going to keep an eye on the page model

  # If our sweeper detects that a page was created call this
  def after_create(page)
    expire_cache_for(page)
  end

  # If our sweeper detects that a page was updated call this
  def after_update(page)
    expire_cache_for(page)
  end

  # If our sweeper detects that a page was deleted call this
  def after_destroy(page)
    expire_cache_for(page)
  end

  private
  def expire_cache_for(page)
    # Expire a fragment
    expire_fragment('page#'+page.id.to_s)
    expire_fragment('page-head#'+page.id.to_s)
    page.navigators.each do |navigator|
      expire_fragment('navigator#'+navigator.block_id.to_s)
    end
  end
end