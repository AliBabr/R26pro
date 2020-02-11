Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post :sign_in
          post :sign_up
          post :log_out
          post :update_password
          post :update_account
          post :forgot_password
          post :reset_password
          get :get_user
          post :save_stripe_token
          get :all_users
        end
        member do
          get :reset
        end
      end

      resources :subscriptions, only: [:create] do
        collection do
          put :cancel_subscription
          put :update_subscription
          post :upgrade_subscription
          get :get_subscription
        end
      end

      resources :coupons, only: %i[create index] do
        collection do
          delete :delete_coupon
        end
      end

      resources :maps, only: %i[create index] do
        collection do
          put :update_map
          delete :destroy_map
          get :get_map
        end
      end

      resources :operator_details, only: %i[create index] do
        collection do
          put :update_detail
          delete :destroy_detail
          get :get_operator_detail
        end
      end

      resources :weapons, only: %i[create index] do
        collection do
          put :update_weapon
          delete :destroy_weapon
          get :get_weapon
        end
      end

      resources :sites, only: %i[create index] do
        collection do
          put :update_site
          delete :destroy_site
          get :get_site
        end
      end

      resources :strategies, only: %i[create index] do
        collection do
          put :update_strategy
          delete :destroy_strategy
          get :get_strategy
        end
      end

      resources :operators, only: %i[create index] do
        collection do
          put :update_operator
          delete :destroy_operator
          get :get_operator
        end
      end

      resources :plans, only: %i[create update destroy index] do
        collection do
          delete :delete_plan
        end
      end
      post "/notifications/toggle_notification", to: "notifications#toggle_notification"
    end
  end

  root to: "home#index"
end
