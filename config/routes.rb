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
