class ArticleController < ThemeController

  before_filter :get_issue, only: [:root, :not_issued_category, :not_issued_article]

  def root
    @articles = Article.home_issue(@issue.number.to_i)
    @url = "/issue/#{@issue.number}"
    render action: :home_issue
  end

  def home_issue
    @articles = Article.home_issue(params[:number].to_i)
    if @articles.empty?
      render_404
    else
      @issue = @articles.first.issue
      @url = home_issue_path(@issue.number)

      render action: :home_issue
    end
  end

  def issued_article
    @article = Article.issued_article(params[:id].to_i, params[:number].to_i,
                                      params[:name])

    if @article.nil?
      render_404
    else
      @issue = @article.issue
      @category = @article.category
      @url = issued_article_path(@issue.number, @category.permalink,
                                 @article.id, @article.prettify_permalink)

      render action: :issued_article
    end
  end

  def issued_category
    @articles = Article.issued_category(params[:number].to_i, params[:name])
    if @articles.empty?
      @issue = Issue.get_public_issue(params[:number].to_i).first
      @issue.nil? ? render_404 : (render action: :empty)
    elsif @articles.size == 1
      redirect_to issued_article_path(@articles.first.issue.number,
                                      @articles.first.category.permalink,
                                      @articles.first.id,
                                      @articles.first.prettify_permalink)
    else
      @issue = @articles.first.issue
      @category = @articles.first.category
      @url = issued_category_path(number: @issue.number, name: @category.permalink)

      render action: :issued_category
    end
  end

  def not_issued_category
    @articles = Article.not_issued_category(params[:name], params[:page])
    if @articles.present?
      @category = @articles.first.category
      page = params[:page].present? ? params[:page] : 1
      @url = not_issued_category_path(name: @category.permalink, page: page)

      render action: :not_issued_category
    else
      render_404
    end
  end

  def not_issued_article
    @article =  Article.not_issued_article(params[:id], params[:name])
    if @article.present?
      @category = @article.category
      @url = not_issued_article_path(name: @category.permalink,id: @article.id,
                                     title: @article.title)
      render action: :not_issued_article
    else
      render_404
    end
  end

  def feed
    @articles = Article.feed(params[:id].to_i)
    render action: "feed.rss.builder", layout: false
  end

end
