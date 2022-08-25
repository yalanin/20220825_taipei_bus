Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'lines#index'

  resources :lines, only: [:show] do
    post :search, on: :collection
  end
end
