# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthController do
  it {
    get '/auth'
    expect(response).to be_successful
  }
  it {
    post '/auth'
    expect(response).to redirect_to(subscriptions_path)
    follow_redirect!
    expect(response).to be_successful
  }
end
