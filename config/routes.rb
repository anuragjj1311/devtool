Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :tabs do
        # General Toggle Routes
        resources :toggles do
          member do
            post :restore
            post :reset
          end
        end

        # Specific Toggle Type Routes
        resources :shop_toggles, only: [:create, :show, :update, :destroy] do
          member do
            post :restore
            post :reset
          end
        end

        resources :category_toggles, only: [:create, :show, :update, :destroy] do
          member do
            post :restore
            post :reset
          end
        end
      end
    end
  end
end
