Rails.application.routes.draw do
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username = 'admin'
    password = 'password'
  end #if Rails.env.production?

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount Sidekiq::Web => '/background_jobs'

  root to: 'homes#dashboard'
  get 'draft', to: 'homes#drafts_only'
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions',
                                   passwords: "users/passwords", confirmations: "users/confirmations"}

  # Users
  resources :users, only: [:update] do
    collection do
      post :remove_avatar
    end
  end

  scope module: 'residential' do
    resources :properties do
      member do
        get :draft
        post :update_energy_data, to: 'properties#update_energy_data'
        post :update_energy_checklist, to: 'properties#update_energy_checklist'
        patch :update_draft
      end
      collection do
        post :remove_data, to: 'properties#remove_data'
      end
    end
    resources :reports do
      member do
        get :audit, to: 'reports#audit'
      end
      collection do
        get :generate, to: 'reports#generate'
      end
    end
  end

  resources :electricity_suppliers do
    collection do
      get :suggestions, to: 'electricity_suppliers#suggestions'
      get :plans, to: 'electricity_suppliers#plans'
      get :retailers, to: 'electricity_suppliers#retailers'
      post :filter_plan, to: 'electricity_suppliers#filter_plan'
      post :fetch_plan_rate, to: 'electricity_suppliers#fetch_plan_rate'
      post :compare_plans, to: 'electricity_suppliers#compare_plans'
    end
  end

  get '/profile', to: 'users#profile'
  post '/check_email_uniqueness', to: 'users#check_email_uniqueness'

  # Categories
  post '/get_sub_categories', to: 'property_categories#get_sub_categories'

  get '/terms_and_conditions', to: 'static_pages#terms_and_conditions'
  get '/privacy_policy', to: 'static_pages#privacy_policy'

  # Get region cities
  post '/get_cities', to: 'regions#get_cities'

  # Ledgers dashboard
  get '/ledgers-dashboard', to: 'ledgers#index'
  post '/get-transaction_list', to: 'ledgers#transaction_list'
  post '/get-transaction-info', to: 'ledgers#transaction_info'

  # Health check Endpoints
  get '/_liveness', to: 'health_checks#health'
  get '/_readiness', to: 'health_checks#health'

  get '*path', to: redirect('/')
end
