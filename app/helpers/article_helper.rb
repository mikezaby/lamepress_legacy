# encoding: UTF-8
module ArticleHelper

  def article_canonical_path(article, issue = nil)
    if article.issue_id.nil?
     not_issued_article_path(article.category_permalink, article.id,
                            article.permalink)
    else
      issued_article_path(issue.number,article.category_permalink,
                        article.id, article.permalink)
    end
  end

  def article_canonical_url(article, issue = nil)
    if article.issue_id.nil?
     not_issued_article_url(article.category_permalink, article.id,
                            article.permalink)
    else
      issued_article_url(issue.number,article.category_permalink,
                        article.id, article.permalink)
    end
  end

  def cat_link(article)
    if article.issue_id.nil?
      not_issued_category_url(article.category.permalink)
    else
      issued_category_url(@issue.number, article.category.permalink)
    end
  end

end
