# frozen_string_literal: true

class AddIsSubscribedToStripeUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_users, :is_subscribed, :boolean, default: false, null: false
  end
end
