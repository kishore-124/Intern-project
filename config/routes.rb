Rails.application.routes.draw do
  resources :tags
  resources :topics do
    resources :posts do
      resources :ratings
      resources :comments
    end
  end
  resources :posts
  root 'topics#index'
end
