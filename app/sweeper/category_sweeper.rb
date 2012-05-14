class CategorySweeper < ActionController::Caching::Sweeper
  observe Category # This sweeper is going to keep an eye on the category model

  # If our sweeper detects that a category was created call this
  def after_create(category)
    expire_cache_for(category)
  end

  # If our sweeper detects that a category was updated call this
  def after_update(category)
    expire_cache_for(category)
  end

  # If our sweeper detects that a category was deleted call this
  def after_destroy(category)
    expire_cache_for(category)
  end

  private
  def expire_cache_for(category)
    category.articles.each do |article|
      expire_fragment('article#'+ article.id.to_s)
      expire_fragment('article-head#'+article.id.to_s)
    end
    if category.issued
      expire_fragment(%r{home_cat#\d+-#{category.id.to_s}})
      expire_fragment(%r{home_cat-head#\d+-#{category.id.to_s}})
      expire_fragment(%r{home_issue#\d+})
    else
      expire_fragment('category-head#'+category.id.to_s)
      expire_fragment('category#'+category.id.to_s)
      expire_fragment(%r{category##{category.id.to_s}#page#\d+})
    end
    category.navigators.each do |navigator|
      expire_fragment("navigator##{navigator.block_id.to_s}")
    end
    expire_fragment(%r{block_category#\d+-#{category.id}})
  end
end
