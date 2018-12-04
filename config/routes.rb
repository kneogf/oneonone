Rails.application.routes.draw do
  get 'jobs/index'

  get 'jobs/new'

  get 'jobs/create'

  get 'jobs/show'

  devise_for :users
  root 'homes#index'
  resources :jobs, only: [:index, :new, :create, :show] do
  	resources :entries
  end
end