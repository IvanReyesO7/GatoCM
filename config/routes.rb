Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :users, param: :username, path: '/', only: [:show, :edit, :update, :destroy] do
    get '/' => 'applications#index', as: :applications_index
    resources :applications, param: :name, path: '/', only: [:show, :edit, :update, :destroy, :new, :create] do
      resources :lists, param: :name_format, path: '/lists/', only: [:show, :new, :create, :edit, :update, :destroy] do
        post "/import" => "lists#import_items"
        resources :items 
      end
      resources :images, param: :name_format, path: '/images/', only: [:show, :new, :create, :edit, :update, :destroy] do
        post "/download" => "images#download"
      end
      resources :codes, param: :name_format, path: '/codes/', only: [:show, :new, :create, :edit, :update, :destroy]
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      scope "/:username/:application_name/" do
        scope "lists" do
          get "/" => "lists#all"
          get "/:list_name_format" => "lists#items"
          get "/:list_name_format/random" => "lists#random"
        end
        scope "codes" do
          get "/:type/:title" => "codes#render_raw"
        end
      end
    end
  end

  get '/:read_token/:user_username/:application_name/codes/:type/:title' => "codes#render_raw"
  get '/:read_token/:user_username/:application_name/images/:name_format/serve' => "images#serve"
end
