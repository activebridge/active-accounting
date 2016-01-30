Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/admin' => 'devise/sessions#new'

    authenticated :user do
      root to: 'home#index'
    end

    unauthenticated :user do
      root to: 'vendor_sessions#new', as: :unauthenticated_root
    end

    get 'home' => 'home#index'

    resources :counterparties do
      collection do
        get :payments
        get :customers
      end
    end

    resources :articles
    resources :registers do
      collection do
        get :sumary_profit
      end
    end
    resources :plan_registers
    resources :invitations
    resources :client_infos, only: :update
    resources :invoices
    resources :work_days, only: :index
    resources :acts
    resources :vendor_acts
    resources :vendor_orders
    resources :order_features
    resources :vendor_infos, only: :update
    resources :holidays
    resources :missing_hours, only: :index
    resources :report_hours, only: :create

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

  resources :hr_home, only: :index

  get '/vendor_login' => 'vendor_sessions#new'
  post 'vendor_login' => 'vendor_sessions#create'
  delete '/vendor_logout' => 'vendor_sessions#destroy'

  get '/vendor_profile' => 'vendor_home#index'

  resources :hours do
    collection do
      get :total_hours
      get :years
      post :approve_hours
      get :confirm
    end
  end

  resources :vendor_password_resets do
    collection do
      post :change_password
    end
  end
end
