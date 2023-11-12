Rails.application.routes.draw do

  devise_for :users
  root to: "homes#top"

  resources :books, only:[:create, :index, :show, :edit, :update, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :users, only:[:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  get 'home/about' => 'homes#about', as: 'about'
  get 'search' => 'searches#search'
  get 'search_result' => 'searches#search_result'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end