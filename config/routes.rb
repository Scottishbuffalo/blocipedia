Rails.application.routes.draw do
  root to: 'welcome#index'
  devise_for :users

  resources :wikis do
    member do
      put :add_collaborator
      put :remove_collaborator
    end
  end

  resources :users
  resources :charges
  resources :subscribers
  resources :charges, only: [:new, :create]
end
