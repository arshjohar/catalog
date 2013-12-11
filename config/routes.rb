Catalog::Application.routes.draw do

  root to: 'home#index'

  resources :products, only: :index

end

