require 'rubygems'
require 'active_record'
require 'i18n'
require 'paperclip'
require 'rails/all'
# coding: UTF-8
I18n.load_path = ['el.yml']
I18n.locale = :el
ActiveRecord::Base.establish_connection(
  :adapter => "mysql2",
  :encoding => "utf8",
	:reconnect => false,
	:database => "1_kodra_db",
	:pool => 5,
	:username => "root",
	:password => "mazda121"
)

class Isue < ActiveRecord::Base
	has_many :artikles
end

class Cattegory < ActiveRecord::Base
  has_many :artikles
end

class Artikle < ActiveRecord::Base
  belongs_to :cattegory
	belongs_to :isue
	belongs_to :media
end

class Media < ActiveRecord::Base
  has_one :article
end




@art = Artikle.all
@cat = Cattegory.all
id = Array.new;title = Array.new; hypertitle = Array.new; html = Array.new; author = Array.new; category_id = Array.new;
issue_id = Array.new; date = Array.new; permalink = Array.new; published = Array.new; url = Array.new; media = Array.new; number = Array.new;

i=0
@art.each do |article|
	url[i]=""
	url[i] = "/"+article.isue.issue_number.to_s unless article.isue_id.nil?
	url[i] += "/"+article.cattegory.cat_name.parameterize+"/"+article.title.parameterize
	id[i]=article.id
	title[i]=article.title
	hypertitle[i]= article.hypertitle
	html[i]=article.body
	author[i]=article.author
	category_id[i] = article.cattegory_id
	issue_id[i]=article.isue_id
	date[i]=article.date.to_s[0..3]+"-"+article.date.to_s[4..5]+"-"+article.date.to_s[6..7]
	published[i] = article.published
	media[i]= article.media.path.split("/").last unless article.media_id.nil?
	number[i] = article.isue.issue_number unless article.isue_id.nil?
	i+=1
end


ActiveRecord::Base.establish_connection(
  :adapter => "mysql2",
  :encoding => "utf8",
	:reconnect => false,
	:database => "mizatron_development",
	:pool => 5,
	:username => "root",
	:password => "mazda121"
)


class Linker < ActiveRecord::Base
	belongs_to :linkerable, :polymorphic => true

	validates :permalink, :uniqueness => true
	attr_accessible :permalink
end

class Article < ActiveRecord::Base
	has_one :linker, :as => :linkerable
	has_one :ordering


  attr_accessible :permalink, :title, :html, :tags, :author, :category_id, :issue_id, :date, :published, :hypertitle, :linker_id, :photo_file_name
end

class Ordering < ActiveRecord::Base
	belongs_to :article
end



i-=1
puts "#Start recording"
for j in (0..i)
  begin
		@article = Article.new; @article.id = id[j]; @article.save!
		@article.update_attributes(:id => id[j], :title => title[j], :hypertitle => hypertitle[j], :html => html[j], :author => author[j], :category_id => category_id[j], :issue_id => issue_id[j], :date => date[j], :published => published[j], :photo_file_name => media[j])
    @article.create_ordering(:cat_pos => 99 ) unless @article.issue_id.nil?
    @article.create_linker(:permalink => url[j])
  rescue Exception => link
    puts "#id=> #{@article.id}, error =>#{link.message}"
  end
end






puts "#end"

