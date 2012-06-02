#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Mizatron::Application.load_tasks

namespace :lp do
  desc "Generate config file for lamepress"
  task :config do
    file = File.expand_path(File.dirname(__FILE__))
    lamepress = File.new("#{file}/config/lamepress.yml", "w")
    lamepress.write("domain: \"http://www.mydomain.com\"\ntitle: \"lamepress\"\nlayout: \"demo\"")
    lamepress.close
  end  
end