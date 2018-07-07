Rails.application.routes.draw do
  # resources :users
  # resources :images
  resources :users do
    resources :images,  only: [:index, :show, :create, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
