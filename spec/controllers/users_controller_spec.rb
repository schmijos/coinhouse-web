require 'spec_helper'

describe UsersController, type: :controller do
  create_logged_in_user

  it 'sees payouts' do
    get :payouts
  end

  it 'sees payouts twice' do
    get :payouts
  end
end