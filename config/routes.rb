Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'zombies#index'
  resources :zombies, only: [:index, :create, :update, :destroy] do
    collection do
      get 'search'
    end
  end
end

