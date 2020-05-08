# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :request do
  it {
    user = create(:user)
    sign_in(user)
    get subscriptions_path
    expect(response).to be_successful
  }
end
