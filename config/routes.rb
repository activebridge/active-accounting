Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root to: 'home#index'
    end

    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end

    get 'home' => 'home#index'

    resources :counterparties do
      collection do
        get :payments
      end
    end

    resources :articles
    resources :registers
    resources :plan_registers
    resources :invitations
    resources :client_infos, only: :update
    resources :invoices, only: :show

    resources :reports do
      collection do
        get :years
      end
    end

    resources :charts do
      collection do
        get :years
      end
    end
  end

    get '/vendor_login' => 'vendor_sessions#new'
    post 'vendor_login' => 'vendor_sessions#create'
    delete '/vendor_logout' => 'vendor_sessions#destroy'

    get '/vendor_profile' => 'vendor_home#index'

    resources :vendor_password_resets do
      collection do
        post :change_password
      end
    end

    resources :hours do
      collection do
        get :customers
        get :total_hours
      end
    end

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
