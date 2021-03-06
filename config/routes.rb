Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  api_version(module: 'V2', path: {value: 'v2'}) do # rubocop:disable Metrics/BlockLength
    resources :work_days, only: [:index] do
      get 'index_active', on: :collection
      put 'close', on: :collection
      get 'print', on: :member
    end
    resources :shifts, only: [:index] do
      get 'index_active', on: :collection
      post 'close', on: :member
      get 'print', on: :member
    end
  end
  api_version(module: 'V1', path: {value: 'v1'}, default: true) do # rubocop:disable Metrics/BlockLength
    resources :booking_places, only: [:index, :create, :update, :show] do
      delete 'close', on: :member
      delete 'open', on: :member
    end
    resources :open_places, only: [:index, :create, :update] do
      delete 'close', on: :member
      post 'add_order', on: :member
      post 'add_hookah_order', on: :member
      post 'add_or_create_order', on: :member
    end
    resources :places, only: [:create, :update, :destroy]
    resources :halls, only: [:index, :create, :update, :destroy]
    resources :work_days, only: [] do
      get 'index', on: :collection
      get 'index_active', on: :collection
      get 'shifts', on: :member
      put 'close', on: :collection
      get 'print', on: :member
    end
    resources :shifts, only: [] do
      get 'index', on: :collection
      get 'index_active', on: :collection
      post 'close', on: :member
      get 'print', on: :member
    end
    resources :encash, only: [:create] do
      get 'index', on: :collection
    end
    resources :orders, only: [:create, :destroy, :update, :index] do
    end
    resources :menu_categories, only: [:create, :destroy, :index] do
    end
    resources :supplies, only: [:create, :index] do
      put 'revert', on: :member
      put 'perform', on: :member
    end
    resources :wastes, only: [:create, :destroy, :update, :index] do
      delete 'revert', on: :member
    end
    resources :inventories, only: [:create, :destroy, :update, :index] do
      post 'done', on: :collection
      post 'later', on: :collection
    end
    resources :checks, only: [:create, :destroy, :update, :index] do
      post 'save', on: :collection
      post 'print', on: :collection
      put 'paid', on: :member
    end
    resources :check_items, only: [:index] do
    end
    resources :store_menu_categories, only: [:create, :destroy, :update, :index] do
      get 'hookah_tech_card_ids', on: :collection
    end
    resources :cash_boxes, only: [:create, :destroy, :update, :index] do
    end
    resources :tech_card_items, only: [:create, :destroy, :update, :index] do
    end
    resources :store_items, only: [:create, :destroy, :update, :index] do
    end
    resources :tech_cards, only: [:create, :destroy, :update, :index] do
      put 'add_category', on: :member
      put 'remove_category', on: :member
      put 'attach', on: :member
      put 'de_attach', on: :member
    end
    resources :ingredients, only: [:create, :destroy, :update, :index] do
      put 'add_category', on: :member
      put 'remove_category', on: :member
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'auth/:provider/callback', to: 'sessions#create'
end
