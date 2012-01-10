Mizatron::Application.routes.draw do



	devise_for :users, :controllers => { :registrations => "admin/user" }

  match '/ajax_handler/:action' => "ajax_handler"
	match '/javascripts/:action.:format' => "javascripts"
  get "base/index"
  root :to => 'linker#forward'

  match "search" => "search#index"

  match '/admin/user/:id/roles' => 'admin/user#roles', :as => "roles_user"
  resources :user, :controller => "admin/user", :path => "admin/user", :as => "users"

  resources :category, :controller => "admin/category", :path => "admin/category", :as => "categories"

  match '/admin/article/reproc' => 'admin/article#reproc'
  resources :article, :controller => "admin/article", :path => "admin/article", :as => "articles"

  match '/admin/issue/reproc' => 'admin/issue#reproc'
	resources :issue, :controller => "admin/issue", :path => "admin/issue", :as => "issues"

	#resources :position, :controller => "admin/position", :path => "admin/position"
	match '/admin/navigator/sorter' => 'admin/navigator#sorter'
	resources :navigator, :controller => "admin/navigator", :path => "admin/navigator", :as => "navigators"
	resources :banner, :controller => "admin/banner", :path => "admin/banner", :as => "banners"
	match '/admin/block/sorter' => 'admin/block#sorter'
	resources :block, :controller => "admin/block", :path => "admin/block", :as => "blocks"
  match '/admin' => 'admin/base#index'

#--> Android service
  match 'mobile/menu' => 'mobile#menu'
  match 'mobile/category' => 'mobile#category'
  match 'mobile/article' => 'mobile#article'
#--> End of Android service

	match 'article.php' => 'linker#php'

	namespace :ckeditor do
    resources :pictures, :only => [:index, :create, :destroy]
  	resources :attachment_files, :only => [:index, :create, :destroy]
  	resources :attachments, :only => [:index, :create, :destroy]
	end

	match '/:perma1(/:perma2(/:perma3))' => 'linker#forward'


end

