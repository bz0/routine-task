Rails.application.routes.draw do
  scope :v1 do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :tasks, only: [:index, :create, :update, :destroy]
  end
end
