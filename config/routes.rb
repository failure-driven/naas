Rails.application.routes.draw do
  namespace :admin do
    resources :notifications

    root to: "notifications#index"
  end
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/naas" => "scripts#index"
  get "test_root", to: "rails/welcome#index", as: "test_root_rails"
end
