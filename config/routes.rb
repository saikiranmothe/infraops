InfraOps::Application.routes.draw do


  ## ----------
  ## APIs
  ## ----------

  # Registration
  post    '/api/v1/register'  =>  "api/v1/registrations#create",  :as => :register

  # Login / Logout
  post    '/api/v1/sign_in'  =>  "api/v1/authentications#create",  :as => :sign_in
  delete  '/api/v1/sign_out' =>  "api/v1/authentications#destroy", :as => :sign_out

  # My Profile
  put    '/api/v1/my_profile'  =>  "api/v1/my_profile#update",  :as => :my_profile

  # ----------------------------
  # Doorkeeper - Oauth Provider
  # ----------------------------

  use_doorkeeper

  # ------------
  # Public pages
  # ------------

  root :to => 'public/user_sessions#sign_in'

  # Sign In URLs for users
  get     '/sign_in',         to: "public/user_sessions#sign_in",         as:  :user_sign_in
  post    '/create_session',  to: "public/user_sessions#create_session",  as:  :create_user_session

  # Logout Url
  delete  '/sign_out' ,       to: "public/user_sessions#sign_out",        as:  :user_sign_out

  # ------------
  # Admin pages
  # ------------

  namespace :admin do

    resources :users do
      get :change_status, on: :member
    end

    resources :projects do
      get :change_status, on: :member
      resources :roles, :only=>[:new, :create, :destroy]
      resources :project_links
    end

    resources :clients
    resources :link_types
    resources :images
    resources :departments
    resources :designations

  end

  # ------------
  # User pages
  # ------------

  namespace :user do
    get   '/dashboard',         to: "dashboard#index",   as:  :dashboard # Landing page after sign in
    get   '/settings',          to: "settings#index",   as:  :settings
    get   '/profile',           to: "profile#index",   as:  :profile
  end

  # User Pages for teams and user profiles
  get   '/team',               to: "user/team#index",   as:  :team
  get   '/profiles/:username',  to: "user/team#show",    as:  :profile

  # User Pages for projects
  get   '/projects/:pretty_url/dashboard',   to: "user/projects#show",   as:  :project_dashboard

  ## ----------
  ## APIs
  ## ----------

  # Login / Logout
  post    '/api/v1/sign_in'  =>  "api/v1/sessions#create",  :as => :api_sign_in
  delete  '/api/v1/sign_out' =>  "api/v1/sessions#destroy", :as => :api_sign_out


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
