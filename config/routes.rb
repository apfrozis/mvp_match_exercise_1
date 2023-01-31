Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login', to: 'authentication#login'

  resources :users do
    put "/deposit" => 'users#deposit'
    put "/buy" => 'users#buy'
    put "/reset" => 'users#reset'
  end

  resources :products


  get '/*a', to: 'application#not_found'
end
