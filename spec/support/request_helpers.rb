require 'spec_helper'

Warden.test_mode!
include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_user
    user = FactoryGirl.create(:user)
    user.confirm!
    login(user)
    user
  end

  def login(user)
    login_as user, scope: :user
  end
end