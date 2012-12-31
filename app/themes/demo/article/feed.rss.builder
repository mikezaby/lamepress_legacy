cache [@category, :feed] do
  xml.instruct! :xml, :version => "1.0"
  xml.rss :version => "2.0" do
    xml.channel do
      xml.title @articles.first.category.name
      xml.description "Categiry #{@articles.first.category.name}"
      xml.lastBuildDate Time.now.to_s(:rfc822)
      xml.link cat_link(@articles.first)

      for article in @articles
        xml.item do
          xml.title article.title
          xml.description article.html.summarize
          xml.pubDate article.created_at.to_s(:rfc822)
          xml.link article_canonical_url(article)
        end
      end
    end
  end
end