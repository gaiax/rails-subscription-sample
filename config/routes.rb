# frozen_string_literal: true

Rails.application.routes.draw do
  root 'subscriptions#show'
  resources :subscriptions, only: ['show']
end
