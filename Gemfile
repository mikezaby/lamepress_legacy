source 'http://rubygems.org'

gem 'rails', '3.2.11'

group :assets do
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :development do
  gem 'quiet_assets'
  gem 'railroady'
  gem 'guard-rspec'
  gem 'ruby_gntp'
  gem 'rb-inotify', '~> 0.8.8'

  #add this two gem for improve queries and page loading time
  gem 'rack-mini-profiler'
  gem 'bullet'
end

gem "ransack"
gem 'jquery-rails'
gem "ckeditor", "3.7.3"
gem "fancybox-rails"
gem 'mysql2', "0.3.10"
gem 'rake', "10.0.3"
gem 'devise'
gem "paperclip"
gem 'kaminari'
gem 'cancan'
gem "nokogiri"
gem 'capistrano', '>= 2.13.5'
gem 'unicorn'

group :test, :development do
  gem 'shoulda-matchers', '>= 1.4.2'
  gem "rspec-rails", "2.12.2"
  gem 'factory_girl_rails', "4.1.0"
  gem 'database_cleaner', '0.9.1'
  gem 'pry-rails'
  gem 'pry-debugger'
end

group :test do
  gem 'spork'
  gem 'guard-spork'
end
