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
  get '/pages/*id' => 'pages#show', as: :page, format: false

  Spree::Core::Engine.add_routes do
    namespace :admin, path: Spree.admin_path do
      resources :service_requests
      end
  end

end