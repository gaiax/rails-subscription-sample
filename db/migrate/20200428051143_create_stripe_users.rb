# frozen_string_literal: true

class CreateStripeUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_users do |t|
      t.integer :user_id, unique: true, null: false
      t.string :customer_id, null: true
      t.string :session_id, null: true
      t.string :subscription_id, null: true
      t.timestamps
    end
  end
end
