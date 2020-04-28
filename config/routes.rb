# frozen_string_literal: true

Rails.application.routes.draw do
  root 'auth#index'
  resources :auth, only: %w[index create]
  resources :subscriptions, only: %w[index] do
    collection do
      get :success, action: 'success'
      get :completed, action: 'completed'
      get :cancel, action: 'cancel'
      get :error, action: 'error'
    end
  end

  resources :unsubscriptions, only: [] do
    collection do
      get :completed, action: 'completed'
    end
  end

  # JavaScriptから叩くAPI
  namespace :api do
    post '/subscriptions', action: :subscribe, controller: :subscriptions
    delete '/subscriptions', action: :unsubscribe, controller: :subscriptions
  end
end
