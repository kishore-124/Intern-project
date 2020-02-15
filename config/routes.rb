Rails.application.routes.draw do
  devise_for :users,path: '',path_names: {sign_in: 'login',sign_out: 'logout',sign_up: 'register'}
  resources :tags
  resources :topics do
    resources :posts do
      resources :ratings
      resources :comments do
        post '/usercomments', to: 'comments#user_comment_rating'
      end
    end
  end

  resources :posts
  root 'topics#index'
  post 'posts/:id/readstatus',  to: 'posts#readstatus'

end
