Mizatron::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, :controllers => { :registrations => "admin/user" }

  match '/ajax_handler/:action' => "ajax_handler"
  match '/assets/djs/:action.:format' => "javascripts"

  get "base/index"
  root :to => 'article#root'

  match "search" => "search#index"
  post "search/issue" => "search#issue"

  namespace :admin do
    resources :user, :as => :users, :except => [:show] do
       get "roles", :on => :member
    end
    resources :page, :as => :pages
    resources :category, :as => :categories, :except => [:show]
    resources :article, :as => :articles do
      get 'page/:page', :action => :index, :on => :collection
      get 'search', :on => :collection
      get 'sitemap', :on => :collection
    end
    resources :ordering, :as => :orderings, :only => [:index, :destroy]  do
      post "update_issue", :on => :collection
      get 'priority', :on => :collection
      post "sorter", :on => :collection
    end

    resources :issue, :as => :issues, :except => [:show]
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

  get '/page/:perma' => 'page#show', as: "page"
  get '/feed/:id' => 'article#feed'

  #isued articles
  get '/issue/:number' => 'article#home_issue', as: 'home_issue'
  get '/issue/:number/:name' => 'article#issued_category', as: 'issued_category'
  get "/issue/:number/:name/:id.:title" => 'article#issued_article', as: 'issued_article'

  #not issued articles
  get '/:name(/page/:page)' => 'article#not_issued_category', as: 'not_issued_category'
  get '/:name/:id.:title' => 'article#not_issued_article', as: 'not_issued_article'

  match '*a', :to => 'application#render_404'

end

