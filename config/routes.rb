Rails.application.routes.draw do
  root to: "owners#index"

  resources :owners do
    resources :machines, only: [:index]
  end

  resources :machines, only: [:show] do
    resources :snacks, controller: "machine_snacks", only: [:create, :destroy]
  end

  resources :snacks, only: [:show]
end
