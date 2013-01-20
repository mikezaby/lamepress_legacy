def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties build-essential" <<
        " libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev" <<
        " libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev" <<
        " autoconf libc6-dev ncurses-dev automake libtool bison subversion openssl" <<
        " libmysqlclient-dev"
  end

  desc "Deploys and starts a `cold' application"
  task :cold do
    update
    load_schema
    start
  end

  task :load_schema, :roles => :app do
    run "cd #{current_path}; bin/rake db:create RAILS_ENV=production"
    run "cd #{current_path}; bin/rake db:schema:load RAILS_ENV=production"
    run "cd #{current_path}; bin/rake db:seed RAILS_ENV=production"
  end

  task :setup_config, roles: :app do
    run "cp #{release_path}/config/application.#{application}.rb #{release_path}/config/application.rb"
    run "ln -nfs #{shared_path}/config/lamepress.yml #{release_path}/config/lamepress.yml"
  end
  after "deploy:finalize_update", "deploy:setup_config"
end
