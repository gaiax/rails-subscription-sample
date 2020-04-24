# frozen_string_literal: true

Rails.application.routes.draw do
  root 'auth#index'
  resources :auth, only: %w[index create]
  resources :user_subscriptions, only: %w[index] do
    collection do
      post :subscribe, action: 'subscribe'
      delete :subscribe, action: 'unsubscribe'
    end
  end

  # JavaScriptから叩くAPI
  namespace :api do
    resources :payments, only: [:create]
  end
end
