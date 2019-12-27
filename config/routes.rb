Rails.application.routes.draw do
  get 'welcome/index'
  root 'articles#index'
  resources :articles do
    resources :comments
  end
end
