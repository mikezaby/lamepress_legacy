Mizatron::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

	devise_for :users, :controllers => { :registrations => "admin/user" }

  match '/ajax_handler/:action' => "ajax_handler"
	match '/assets/djs/:action.:format' => "javascripts"

  get "base/index"
  root :to => 'linker#root'

  match "search" => "search#index"

  namespace :admin do
    resources :user, :as => :users, :except => [:show] do
       get "roles", :on => :member
    end
    resources :page, :as => :pages
    resources :category, :as => :categories, :except => [:show]
    resources :article, :as => :articles do
      get "reproc", :on => :collection
      get 'page/:page', :action => :index, :on => :collection
      get 'search', :on => :collection
      get 'sitemap', :on => :collection
    end
    resources :ordering, :as => :orderings, :only => [:index, :destroy]  do
      post "update_issue", :on => :collection
      get 'priority', :on => :collection
      post "sorter", :on => :collection
    end

    resources :issue, :as => :issues, :except => [:show] do
      get "reproc", :on => :collection
    end
    resources :navigator, :as => :navigators, :except => [:show] do
      post "sorter", :on => :collection
    end
    resources :block, :as => :blocks, :except => [:show] do
      post "sorter", :on => :collection
    end
    resources :banner, :as => :banners, :except => [:show] do
      post "sorter", :on => :collection
    end
    resources :setting, :as => :settings, :only => [:create, :update, :destroy] do
      get "current_issue", :on => :collection
      get "block_placements", :on => :collection
    end
  end

  match '/admin' => 'admin/base#index'

#--> Android service
  match 'mobile/menu' => 'mobile#menu'
  match 'mobile/category' => 'mobile#category'
  match 'mobile/article' => 'mobile#article'
#--> End of Android service

	match '/article.php' => 'linker#php'

  match '/feed/:id' => 'linker#feed'
  match '/issue_:perma1(/:perma2/page/:page)' => 'linker#issued'
	match '/issue_:perma1(/:perma2(/:perma3(/page/:page)))' => 'linker#issued'
  match '/:perma1/page/:page' => 'linker#non_issued'
  match '/:perma1((/page/:page)/:perma2)' => 'linker#non_issued'

end

