Rails.application.routes.draw do
  root 'companies#index'
  
  resources :companies, only: [:index]
  
  namespace :admin do
    resources :imports, only: [:new_admin_import, :new, :create]
  end
end