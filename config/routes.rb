Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :eth_to_ebcs, only: [:index]
      resources :ebc_to_eths, only: [:index]
    end
  end
end
