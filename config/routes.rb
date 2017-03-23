Rails.application.routes.draw do
  api_version(module: 'V1', path: {value: 'v1'}, default: true) do
    resources :checks, only: [:create, :destroy, :update] do
      get 'index', on: :collection
    end
    resources :check_items, only: [] do
      get 'index', on: :collection
    end
    resources :store_menu_categories, only: [:create, :destroy, :update] do
      get 'index', on: :collection
    end
    resources :cash_boxes, only: [:create, :destroy, :update] do
      get 'index', on: :collection
    end
    resources :tech_card_items, only: [:create, :destroy, :update] do
      get 'index', on: :collection
    end
    resources :store_items, only: [:create, :destroy, :update] do
      get 'index', on: :collection
    end
    resources :tech_cards, only: [:create, :destroy, :update] do
      get 'index', on: :collection
      put 'add_category', on: :member
      put 'remove_category', on: :member
    end
    resources :ingredients, only: [:create, :destroy, :update] do
      get 'index', on: :collection
      put 'add_category', on: :member
      put 'remove_category', on: :member
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'auth/:provider/callback', to: 'sessions#create'
end
