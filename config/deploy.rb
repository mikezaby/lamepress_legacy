require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/mysql"
load "config/recipes/rbenv"
load "config/recipes/check"

set :bundle_flags, "--deployment --quiet --binstubs"

set :application, "lamepress"
set :domain, "domain.com"
server "37.247.54.81", :web, :app, :db, primary: true
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/lamepress"

set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:mikezaby/lamepress.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true


after "deploy", "deploy:cleanup" # keep only the last 5 releases
