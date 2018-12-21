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
  get '/services/*id' => 'pages#show', as: :page, format: false
  post '/services/*id' => 'pages#create_request', as: :create_request, format: false

  Spree::Core::Engine.add_routes do
    namespace :admin, path: Spree.admin_path do
      resources :service_requests
      resources :companies do
        get '/get_departments', to: 'companies#get_departments', as: 'get_departments'
        get '/departments', to: 'departments#index', as: 'departments'
        get '/departments/new', to: 'departments#new', as: 'new_department'
        get '/departments/edit/:id', to: 'departments#edit', as: 'edit_department'
        member do
          match '/addresses' => 'companies#addresses', via: [:get, :put]
        end
      end

      resources :departments
      get '/pages/*id' => 'pages#show', as: :page, format: false

      resources :products do
        get '/sale', to: 'products#sale', as: 'sale'
      end

      resources :product_sales, as: 'sale'
    end
  end


  namespace :manage do
    get '/', to: 'orders#index'
    resources :orders
  end

end