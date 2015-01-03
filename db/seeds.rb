User.create!(email: "demo@email.com", password: "lamepress", roles_mask: "7")

Block.create!(position: 1, name: "cover", mode: "cover", partial: "cover", placement: "left")
block_top = Block.create!(position: 1, name: "menu", mode: "navigator", partial: "menu", placement: "top")
category = Category.create!(name: "Category", issued: true)
Navigator.create!(name: "Category", block_id: block_top.id, position: 1,
                 navigatable_type: "Category", navigatable_id: category.id)

(1..10).each do |number|
  issue = Issue.create!(number: number, published: true, date: number.months.ago,
                       cover: File.new("#{Rails.root}/public/issue.png", "r"),
                       pdf: File.new("#{Rails.root}/public/issue.pdf", "r"))
  (1..10).each do |x|
    article = issue.articles.create!(title: Faker::Lorem.sentence, published: true,
                                    category_id: category.id, date: Date.today, html: Faker::Lorem.paragraph)
    article.create_ordering(issue_pos: x, cat_pos: x)
  end
end


Setting.create!(meta_key: "current_issue", meta_value: "#{Issue.last.id}")
Setting.create!(meta_key: "block_placement", meta_value: "top")
Setting.create!(meta_key: "block_placement", meta_value: "left")
Setting.create!(meta_key: "block_placement", meta_value: "right")
