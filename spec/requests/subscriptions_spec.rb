# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController do
  before {
    post '/auth'
  }
  it {
    get '/subscriptions'
    expect(response).to be_successful
  }
end
