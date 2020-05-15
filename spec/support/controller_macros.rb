# frozen_string_literal: true

# https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
# module ControllerMacros
#   def login_user(user)
#     controller.stub(:authenticate_user!).and_return true
#     @request.env['devise.mapping'] = Devise.mappings[:user]
#     sign_in user
#   end
# end
