Rails.application.routes.draw do

  get '/users/:id/transfer_points', to: 'users#transfer_points', as: 'transfer_points'
  post '/users/:id/transfer/:destination_user_id', to: 'users#transfer', as: 'transfer'
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
