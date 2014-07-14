#Add routes to existing foreman resources
Rails.application.routes.draw do
  resources :operatingsystems, :except => [:show] do
    member do
      get 'available_kickstart_repo'
    end
  end
end

Katello::Engine.routes.draw do

  resources :content_search do
    collection do
      post :errata
      post :products
      post :packages
      post :puppet_modules
      post :packages_items
      post :errata_items
      post :puppet_modules_items
      get :view_packages
      get :view_puppet_modules
      post :repos
      post :views
      get :repo_packages
      get :repo_errata
      get :repo_puppet_modules
      get :repo_compare_packages
      get :repo_compare_errata
      get :repo_compare_puppet_modules
      get :view_compare_packages
      get :view_compare_errata
      get :view_compare_puppet_modules
    end
  end

  resources :content_views, :only => [:index] do
    collection do
      get :auto_complete
    end
  end

  resources :sync_management, :only => [:destroy] do
    collection do
      get :index
      get :sync_status
      post :sync
    end
  end

  get "notices/note_count"
  get "notices/get_new"
  get "notices/auto_complete_search"
  match 'notices/:id/details' => 'notices#details', :via => :get, :as => 'notices_details'
  match 'notices' => 'notices#show', :via => :get
  match 'notices' => 'notices#destroy_all', :via => :delete

  resources :dashboard, :only => [:index] do
    collection do
      get :sync
      get :notices
      get :errata
      get :content_views
      get :promotions
      get :host_collections
      get :subscriptions
      get :subscriptions_totals
      put :update
    end
  end

  resources :packages, :only => [] do
    member do
      get :details
    end
    collection do
      get :auto_complete
    end
  end

  resources :puppet_modules, :only => [:show] do
    collection do
      get :auto_complete
      get :author_auto_complete
    end
  end

  resources :distributors do
    resources :events, :only => [:index, :show], :controller => "distributor_events" do
      collection do
        get :status, action: :distributor_status
        get :more_events
        get :items
      end
    end

    member do
      get :edit
      get :subscriptions
      post :update_subscriptions
      get :products
      get :more_products
      get :download
      get :custom_info
    end
    collection do
      get :auto_complete
      get :items
      get :env_items
      get :environments
      delete :bulk_destroy
    end
  end

  resources :errata, :only => [:show] do
    collection do
      get :auto_complete
    end
    member do
      get :short_details
    end
  end

  resources :products, :only => [] do
    member do
      get :available_repositories
      put :toggle_repository
    end
    collection do
      get :auto_complete
      get :all
    end
  end

  resources :users do
    collection do
      get :auto_complete_search
      get :items
      post :enable_helptip
      post :disable_helptip
    end
    member do
      post :clear_helptips
      put :update_roles
      put :update_locale
      put :update_preference
      put :setup_default_org
      get :edit_environment
      put :update_environment
    end
  end

  resources :providers do
    collection do
      get :auto_complete_search
      get :redhat_provider
      get :redhat_provider_tab
    end
  end

  match '/providers/:id' => 'providers#update', :via => :put
  match '/providers/:id' => 'providers#update', :via => :post

  resources :repositories, :only => [:new, :create, :edit, :destroy] do
    collection do
      get :auto_complete_library
    end
  end

  resources :promotions, :only => [] do
    collection do
      get :index, :action => :show
    end
    member do
      get :show
      get :details
      get :content_views
    end
  end

  resources :organizations do
    collection do
      get :auto_complete_search
      get :items
      get :default_label
    end
    member do
      get :show
      get :events
      get :download_debug_certificate
      get :apply_default_info_status
    end
  end
  match '/organizations/:id/edit' => 'organizations#update', :via => :put
  match '/organizations/:id/default_info/:informable_type' => 'organizations#default_info', :via => :get, :as => :organization_default_info

  resources :search, :only => {} do
    get 'show', :on => :collection

    get 'history', :on => :collection
    delete 'history' => 'search#destroy_history', :on => :collection

    get 'favorite', :on => :collection
    post 'favorite' => 'search#create_favorite', :on => :collection
    delete 'favorite/:id' => 'search#destroy_favorite', :on => :collection, :as => 'destroy_favorite'
  end

  root :to => "dashboard#index"

  match '/user_session/set_org' => 'user_sessions#set_org', :via => :post

end
