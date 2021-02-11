Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :sites
    resources :users
    resources :site_users
    resources :keys
    resources :notifications

    root to: "notifications#index"
  end
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/naas" => "scripts#index", as: :widget
  get "test_root", to: "rails/welcome#index", as: "test_root_rails"

  resources :sites, only: %i[index create new show edit update] do
    member do
      get :notifications
      get :metrics
      get :access
      get :settings
      get :create_key
      delete :destroy_key
    end
  end

  authenticated :user do
    get "/", to: redirect("/sites")
    # root to: "sites#index"
    # root to: redirect("/sites")
  end
  root to: "home#index"
end
