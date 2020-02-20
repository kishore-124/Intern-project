Rails.application.routes.draw do
  devise_for :users,path: '',path_names: {sign_in: 'login',sign_out: 'logout',sign_up: 'register'}, controllers: {conformations: 'users/conformations'}

  resources :tags
  resources :topics do
    resources :posts do
      resources :ratings
      resources :comments do
        post '/user_comment_ratings', to: 'comments#user_comment_rating'
      end
    end
  end

  resources :posts
  root 'topics#index'
  post 'posts/:id/read_status', to: 'posts#read_status'

end
