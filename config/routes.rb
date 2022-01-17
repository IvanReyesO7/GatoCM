Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :users, param: :username, path: '/', only: [:show, :edit, :update, :destroy] do
    get '/' => 'applications#index', as: :applications_index
    resources :applications, param: :name, path: '/', only: [:show, :edit, :update, :destroy] do
      resources :lists, param: :name_format, path: '/lists/', only: [:show, :new, :create, :edit, :update, :destroy] do
        resources :items
      end
      resources :images, param: :name_format, path: '/images/', only: [:show, :new, :create, :edit, :update, :destroy]
      resources :codes, param: :name_format, path: '/codes/', only: [:show, :new, :create, :edit, :update, :destroy]
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      scope "/:username/:application_name/" do
        get "/lists" => "lists#all"
        get "/lists/:list_name_format" => "lists#items"
        get "/lists/:list_name_format/random" => "lists#random"
      end
    end
  end
end
