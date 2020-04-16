# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController do
  it {
    get '/'
    expect(response).to be_successful
  }
end
