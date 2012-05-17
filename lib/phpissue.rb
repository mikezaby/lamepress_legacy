require 'rubygems'
require 'active_record'
require 'rails/all'
require 'paperclip'

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

end

@iss = Isue.find(:all)
	puts "y0"
@iss.each do |iss|
	puts iss.id
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

class Issue < ActiveRecord::Base
  has_many :articles, :dependent => :destroy
	has_one :current_issue

end

@iss.each do |iss|
  puts date=iss.issue_date.to_s[0..3]+"-"+iss.issue_date.to_s[4..5]+"-"+iss.issue_date.to_s[6..7]
	puts cover_path = iss.cover_path.split("/").last
	puts pdf_path = iss.pdf_path.split("/").last
	@issue = Issue.new; @issue.id = iss.id; @issue.save!
	@issue.update_attributes(:id => iss.id, :number => iss.issue_number, :date => date, :published => iss.published, :cover_file_name => cover_path, :cover_content_type => "image/jpeg", :pdf_file_name => pdf_path, :pdf_content_type => "application/pdf")
end
puts "#end"

