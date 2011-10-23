Mizatron::Application.routes.draw do



	devise_for :users, :controllers => { :registrations => "admin/user" }

  match '/ajax_handler/:action' => "ajax_handler"
	match '/javascripts/:action.:format' => "javascripts"
  get "base/index"
  root :to => 'linker#forward'
  resources :user, :controller => "admin/user", :path => "admin/user"
  resources :category, :controller => "admin/category", :path => "admin/category"

  match '/admin/article/reproc' => 'admin/article#reproc'
  resources :article, :controller => "admin/article", :path => "admin/article"

  match '/admin/issue/reproc' => 'admin/issue#reproc'
	resources :issue, :controller => "admin/issue", :path => "admin/issue"

	resources :position, :controller => "admin/position", :path => "admin/position"
	match '/admin/navigator/sorter' => 'admin/navigator#sorter'
	resources :navigator, :controller => "admin/navigator", :path => "admin/navigator"
	resources :banner, :controller => "admin/banner", :path => "admin/banner"
	match '/admin/block/sorter' => 'admin/block#sorter'
	resources :block, :controller => "admin/block", :path => "admin/block"
  match 'admin' => 'admin/base#index'
  match 'mobile/menu' => 'mobile#menu'
	#match '/c/:permalink' => 'admin/category#show'

	match 'article.php' => 'linker#php'

	namespace :ckeditor do
    resources :pictures, :only => [:index, :create, :destroy]
  	resources :attachment_files, :only => [:index, :create, :destroy]
  	resources :attachments, :only => [:index, :create, :destroy]
	end

	match '/:perma1(/:perma2(/:perma3))' => 'linker#forward'


end

