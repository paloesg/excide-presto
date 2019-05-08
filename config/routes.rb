Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/products-load/:id', to: 'spree/products#show_modal'
  get '/services-load/:id', to: 'spree/services#show_modal'

  Spree::Core::Engine.add_routes do
    resources :services
    resources :service_requests
    match '/orders/:id/reorder' => 'orders#reorder', :via => :post, :as => :reorder_order
    match '/orders/:id/override_purchase_order' => 'orders#override_purchase_order', :via => :post, :as => :override_purchase_order
    match '/orders/:id/reorder' => 'orders#edit_rejected', :via => :get, :as => :edit_rejected
    match '/orders/:id/reorder' => 'orders#reorder_rejected', :via => :patch, :as => :reorder_rejected
    resource :account, controller: 'users' do
      get '/password' => 'users#password', as: 'password'
    end
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :shipments, only: [:create, :update] do
          member do
            put :delivery
          end
        end
      end
    end
    namespace :admin, path: Spree.admin_path do
      resources :products do
        resources :product_sales
      end
      resources :product_sales

      resources :service_requests
      resources :services

      resources :companies do
        get '/get_departments', to: 'companies#get_departments', as: 'get_departments'
        #departments in company
        resources :departments do
          member do
            get 'managers' => 'departments#managers'
          end
        end
        #roles in company
        resources :roles
        get '/roles/:id/users', to: 'roles#users', as: 'users_role'
        member do
          match '/addresses' => 'companies#addresses', via: [:get, :put]
        end
      end
      resources :departments

      resources :users do
        put '/update/role', to: 'users#update_role', as: 'update_roles'
      end
      get '/pages/*id' => 'pages#show', as: :page, format: false
    end

    get "/cart_partial" => 'orders#cart_partial', as: 'cart_partial'
    get "/reorder_partial/:id/:order_number" => 'orders#reorder_partial', as: 'reorder_partial'
    get "/remaining_budget_partial" => 'products#remaining_budget_partial', as: 'remaining_budget_partial'
    get "/product_partial" => 'products#product_partial', as: 'product_partial'
    get "/taxon_product_partial" => 'taxons#taxon_product_partial', as: 'taxon_product_partial'
  end

  namespace :manage do
    get '/', to: 'orders#index'
    resources :orders, param: :order_id do
      member do
        post :approve, to: 'orders#approve'
        post :reject, to: 'orders#reject'
      end
    end
  end
end
