Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login', to: 'authentication#login'
  post '/logout/all', to: 'authentication#logout'

  resources :users, except: [:update] do
    collection do
      put '' => 'users#update'
      put "/deposit" => 'users#deposit'
      put "/buy" => 'users#buy'
      put "/reset" => 'users#reset'
    end
  end

  resources :products


  get '/*a', to: 'application#not_found'
end
