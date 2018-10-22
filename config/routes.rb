Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      # resources :eth_to_ebcs, only: [:index]
      # resources :ebc_to_eths, only: [:index]
      get "/eth_to_ebcs/:address", to: "eth_to_ebcs#index"
      get "/ebc_to_eths/:address", to: "ebc_to_eths#index"
    end
  end
end
