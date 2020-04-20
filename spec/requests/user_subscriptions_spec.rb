# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSubscriptionsController do
  it {
    get '/'
    expect(response).to be_successful
  }
end
