Rottenpotatoes::Application.routes.draw do
  resources :movies do
    get :from_same_director, on: :member
  end

  root to: 'movies#index'
end
