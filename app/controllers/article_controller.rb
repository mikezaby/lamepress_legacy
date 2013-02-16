class ArticleController < ThemeController

  include ArticleHelper
  before_filter :fetch_issue, expect: [:feed]

  def home_issue
    @articles = @issue.articles.home
  end

  def issued_article
    @article = @issue.articles.includes(:category).published_only.find(params[:id])

    redirect_to_canonical
  end

  def issued_category
    @category = Category.issued.find_by_permalink!(params[:name])
    @articles = @issue.articles.for_category(@category.id).order_category
  end

  def not_issued_category
    page = params[:page].present? ? params[:page] : 1
    @category = Category.non_issued.find_by_permalink!(params[:name])
    @articles = @category.articles.published_only.
                          order("date #{@category.ordered}").
                          page(page).per(10)
  end

  def not_issued_article
    @article =  Article.includes(:category).non_issued.published_only.find(params[:id])
    @category = @article.category

    redirect_to_canonical
  end

  def feed
    @category = Category.non_issued.find(params[:id])
    @articles = @category.articles.published_only

    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  private
  def redirect_to_canonical
    if request.path != article_canonical_path(@article, @issue)
      redirect_to(article_canonical_path(@article, @issue), status: :moved_permanently)
    end
  end
end
