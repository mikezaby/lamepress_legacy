cache 'feed#'+@category.id.to_s do
  xml.instruct! :xml, :version => "1.0" 
  xml.rss :version => "2.0" do
    xml.channel do
      xml.title @category.name
      xml.description "Categiry #{@category.name}"
      xml.lastBuildDate Time.now.to_s(:rfc822)
      xml.link @category.issued ? "#{$domain}/issue_#{@posts.first.issue_number}/#{@category.name}" : "#{$domain}/#{@category.name}"

      for post in @posts
        xml.item do
          xml.title post.title
          xml.description post.html.summarize
          xml.pubDate post.created_at.to_s(:rfc822)
          xml.link @category.issued ? "#{$domain}/issue_#{post.issue_number}/#{@category.name}/#{post.id}-#{post.prettify_permalink}" : "#{$domain}/#{@category.name}/#{post.id}-#{post.prettify_permalink}"      
        end
      end
    end
  end
end