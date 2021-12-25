Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  resources :users, param: :username, path: '/', only: [:show, :edit, :update, :destroy] do
    get '/applications' => 'applications#index', as: :applications_index
    resources :applications, param: :name, path: '/', only: [:show, :edit, :update, :destroy] do
      resources :lists, param: :name_format, path: '/list/', only: [:show, :edit, :update, :destroy]
      resources :images, param: :name_format, path: '/image/', only: [:show, :edit, :update, :destroy]
      resources :codes, param: :name_format, path: '/code/', only: [:show, :edit, :update, :destroy]
    end
  end
end
