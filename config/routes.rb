Mizatron::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

	devise_for :users, :controllers => { :registrations => "admin/user" }

  match '/ajax_handler/:action' => "ajax_handler"
	match '/assets/djs/:action.:format' => "javascripts"

  get "base/index"
  root :to => 'linker#forward'

  match "search" => "search#index"

  namespace :admin do
    resources :user, :as => :users do
       get "roles", :on => :member
    end
    resources :category, :as => :categories
    resources :article, :as => :articles do
      get "reproc", :on => :collection
    end
    resources :issue, :as => :issues do
      get "reproc", :on => :collection
    end
    resources :navigator, :as => :navigators do
      get "sorter", :on => :collection
    end
    resources :block, :as => :blocks
    resources :banner, :as => :banners
  end

  match '/admin' => 'admin/base#index'

#--> Android service
  match 'mobile/menu' => 'mobile#menu'
  match 'mobile/category' => 'mobile#category'
  match 'mobile/article' => 'mobile#article'
#--> End of Android service

	match 'article.php' => 'linker#php'


	match '/:perma1(/:perma2(/:perma3))' => 'linker#forward'


end

