Rails.application.routes.draw do
  resources :plot_plants, only: [:destroy]
  resources :plants
  resources :plots, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
