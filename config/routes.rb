Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :zombies, only: [:create, :update] do
    collection do
      get 'search'
    end
  end
end

