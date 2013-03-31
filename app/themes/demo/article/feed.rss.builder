cache [:feed, @category, :v2] do
  xml.instruct! :xml, version: "1.0"
  xml.rss version: "2.0", 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
    xml.channel do
      xml.title @articles.first.category.name
      xml.description "Categiry #{@articles.first.category.name}"
      xml.lastBuildDate Time.now.to_s(:rfc822)
      xml.link cat_link(@articles.first)
      xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml',
                href: category_feed_url(@articles.first.category.id, "rss")

      for article in @articles
        xml.item do
          xml.title article.title.gsub(/&amp;/, "&")
          xml.description article.html.summarize
          xml.pubDate article.created_at.to_s(:rfc822)
          xml.link article_canonical_url(article)
          xml.guid article_canonical_url(article)
        end
      end
    end
  end
end