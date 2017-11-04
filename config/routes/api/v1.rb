Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :wallets, only: [:index]
      resources :red_bags, only: [:create, :show, :index] do
        get :grab, on: :collection
      end
    end
  end
end