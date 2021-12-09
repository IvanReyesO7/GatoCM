Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  resources :users, param: :username, path: '/', only: [:show, :edit, :update, :destroy] do
    resources :applications
  end
end
