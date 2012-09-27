module ArticleHelper

  def article_permalink(article)
    if article.issue_id.nil?
     not_issued_article_url(article.category.permalink,
                              article.id,
                              article.prettify_permalink)
    else
      issued_article_url(article.issue.number,
                          article.category.permalink, article.id,
                          article.prettify_permalink)
    end
  end

  def cat_link(article)
    if article.issue_id.nil?
      not_issued_category_url(article.category.permalink)
    else
      issued_category_url(article.issue.number, article.category.permalink)
    end
  end

end
