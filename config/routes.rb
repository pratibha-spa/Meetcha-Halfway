Rails.application.routes.draw do
  devise_for :app_users, skip: [:sessions, :passwords, :registrations]
  devise_for :admin_users, skip: [:registrations]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  namespace :api do
    namespace :v1 do
      devise_scope :app_user do
        post 'sign_in' => 'sessions#create', :as => 'login'
      end
      match 'new_app_user' => 'app_users#create', :via => :post
      match 'update_user' => 'app_users#update_app_user', :via => :post
      match 'search_contact' => 'search_contacts#search_through_contact', :via => :post
      match 'create_meeting' => 'meeting_details#create_meeting', :via => :post
      match 'update_meeting' => 'meeting_details#update_meeting', :via => :post
      match 'update_your_location' => 'journey_updates#save_your_current_location', :via => :post
      match 'fetch_location' => 'journey_updates#fetch_others_current_location', :via => :get
      match 'meeting_history' => 'search_contacts#show_meeting_history', :via => :get
      match 'confirm_meeting' => 'meeting_details#meeting_accept_notification', :via => :get
      match 'change_password' => 'app_users#change_password', :via => :post
      match 'forget_password' => 'app_users#recover_password', :via => :post
    end
  end    

  # You can have the root of your site routed with "root"
  root 'home#index'
  resources :admin_users
  resources :app_users
  resources :meeting_details
  resources :journey_updates
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
