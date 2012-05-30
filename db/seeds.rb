# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
require "custom_strings.rb"
User.create(email: "demo@email.com", password: "lamepress", roles_mask: "7")
issue = Issue.create(number: 1, published: true, date: Date.today,  cover: File.new("#{Rails.root}/public/issue.png", "r"), pdf: File.new("#{Rails.root}/public/issue.pdf", "r"))
Setting.create(meta_key: "current_issue", meta_value: "#{issue.id}")
Setting.create(meta_key: "block_placement", meta_value: "top")
Setting.create(meta_key: "block_placement", meta_value: "left")
Setting.create(meta_key: "block_placement", meta_value: "right")
Block.create(position: 1, name: "cover", mode: "cover", partial: "cover", placement: "left")
block_top = Block.create(position: 1, name: "menu", mode: "navigator", partial: "menu", placement: "top")
category = Category.create(name: "Category", issued: 1)
Navigator.create(name: "Category", block_id: block_top.id, position: 1, navigatable_type: "Category", navigatable_id: category.id)
article = Article.create(title: "Lamepress CMS", published: true, category_id: category.id, issue_id: issue.id, date: Date.today, html: "Lamepress is a Content System Managment for issuing magazines/newspapers. It's written in Ruby language and rails framework. The deal of Lamepress is to make building and managing of magazines/newspapers as simple and easy as possible, also to give readers an easy way to browse current and older issues. Lamepress is under MIT Liecense.")
article.create_ordering(issue_pos: 1, cat_pos: 1)