Rails.application.routes.draw do
  get "dashboard/index"
  get "home/index"
  devise_for :users

  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  root "home#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :accounts do
    resources :balance_sheets, except: [ :index ]
    resources :budgets
  end

  resources :balance_sheets, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
    member do
      get :report
      post :duplicate
    end
  end

  resources :budgets, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]

  resources :reports, only: [ :index ] do
    collection do
      get :balance_sheet, path: "balance_sheet"
    end
  end

  resource :data_export, only: [ :show, :create ]

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
