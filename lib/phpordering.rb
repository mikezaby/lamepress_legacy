require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql2",
  :encoding => "utf8",
	:reconnect => false,
	:database => "1_kodra_db",
	:pool => 5,
	:username => "root",
	:password => "mazda121"
)

class Priority < ActiveRecord::Base
end

class HomePriority < ActiveRecord::Base
end




@pri = Priority.all
@hpri = HomePriority.all
i=0
j=0
artid=Array.new
prior=Array.new
artidj=Array.new
priorj=Array.new
@pri.each do |pri|
	artid[i]=pri.article_id
	prior[i]=pri.priority
	i+=1
end
max=i-1
@hpri.each do |hpri|
	artidj[j]=hpri.article_id
	priorj[j]=hpri.home_priority
	j+=1
end
maxj=j-1


ActiveRecord::Base.establish_connection(
  :adapter => "mysql2",
  :encoding => "utf8",
	:reconnect => false,
	:database => "mizatron_development",
	:pool => 5,
	:username => "root",
	:password => "mazda121"
)


class Ordering < ActiveRecord::Base
	belongs_to :article
end

class Article < ActiveRecord::Base
	has_one :ordering
end

for i in (0..max)
	begin
	  if (@article = Article.find_by_id(artid[i]))
	    order = @article.ordering
		  order.update_attributes(:cat_pos => prior[i])
	  end
	rescue Exception => link
    puts "#id=> #{@article.id}, error =>#{link.message}"
  end
end

for i in (0..maxj)
  begin
	  if (@article = Article.find_by_id(artidj[i]))
	    order = @article.ordering
		  order.update_attributes(:issue_pos => priorj[i])
	  end
	rescue Exception => link
    puts "#id=> #{@article.id}, error =>#{link.message}"
  end
end







puts "#end"

