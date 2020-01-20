Rails.application.routes.draw do

  #root 'topics#index'
  resources :topics do
    resources :posts
  end

  get 'welcome/index'
  resources :articles do
    resources :comments
  end
end
