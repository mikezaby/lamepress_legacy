module LinkerHelper

  def article_permalink(article)
  	linkzor = ""
	linkzor = "/issue_#{article.issue_number}" unless article.issue_id.nil?
	linkzor += "/#{article.category_permalink}/#{article.id}-#{article.prettify_permalink}"
  end

  def cat_link(article)
	linkzor = "/"
	linkzor += "issue_"+article.issue_number.to_s+"/" unless article.issue_id.nil?
	linkzor += article.category_permalink
  end

end
