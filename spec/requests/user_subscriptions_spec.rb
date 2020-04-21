# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSubscriptionsController do
  it {
    get '/user_subscriptions'
    expect(response).to be_successful
  }
  it {
    post '/user_subscriptions/subscribe'
    follow_redirect!
    expect(response.body).to include('購読しました')
    expect(response).to be_successful
  }
  it {
    delete '/user_subscriptions/subscribe'
    follow_redirect!
    expect(response.body).to include('購読を解除しました')
    expect(response).to be_successful
  }
end
