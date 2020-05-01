# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, if: :protected_with_csrf_token

  protected

  def protected_with_csrf_token
    true
  end
end
