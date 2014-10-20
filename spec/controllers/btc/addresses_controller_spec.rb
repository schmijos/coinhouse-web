require 'spec_helper'

describe Btc::AddressesController, type: :controller do
  create_logged_in_user

  describe "POST addresses" do

    it "creates a valid new addresses" do
      some_hash = Faker::Bitcoin.address

      post :create, the_hash: some_hash

      btc_address = BtcAddress.find_by_the_hash(some_hash)
      expect(btc_address).to be_present
      expect(btc_address.the_hash).to eq(some_hash)
      expect(btc_address).to be_available
      expect(btc_address).not_to be_paid
      expect(btc_address).not_to be_ready_to_payout
    end

    it "doesn't create invalid addresses" do
      some_hash = 12345

      post :create, the_hash: some_hash
      btc_address = BtcAddress.find_by_the_hash(some_hash)
      expect(btc_address).to be_blank
    end
  end

  describe "PATCH addresses/:hash" do
    it "sets a new balance on freshly assigned addresses" do
      a_balance = 1.23434223355.to_f
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address, user: create(:user))

      patch :update_balance, the_hash: btc_address.the_hash, balance: a_balance
      btc_address.reload
      expect(btc_address.balance).to eq(a_balance)
    end

    it "doesn't update the balance of available addresses" do
      a_balance = 1.23434223355.to_f
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address)
      old_balance = btc_address.balance

      patch :update_balance, the_hash: btc_address.the_hash, balance: a_balance
      btc_address.reload
      expect(btc_address.balance).to eq(old_balance)
    end

    it "doesn't update the balance on an already paid address" do
      a_balance = 1.23434223355.to_f
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address, balance: 1, target_balance: 1)
      btc_address.payout = create(:payout)
      old_balance = btc_address.balance

      patch :update_balance, the_hash: btc_address.the_hash, balance: a_balance
      btc_address.reload
      expect(btc_address.balance).to eq(old_balance)
    end

    it "doesn't set a balance on addresses which are scheduled for payout" do
      a_balance = 1.23434223355.to_f
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address)
      old_balance = btc_address.balance

      patch :update_balance, the_hash: btc_address.the_hash, balance: a_balance
      btc_address.reload
      expect(btc_address.balance).to eq(old_balance)
    end
  end

  describe "GET addresses/needed" do
    it "pledges for an amount of needed new addresses"

    it "doesn't pledge for new addresses if there are enough of them"
  end

  describe "PATCH addresses/:the_hash/try_clearance" do
    it "clears an address if it is clearable" do
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address, user: create(:user), balance: 1.5, target_balance: 1.4)
      expect(btc_address).to be_clearable

      patch :try_clearance, the_hash: btc_address.the_hash
      btc_address.reload
      expect(btc_address).to be_cleared
    end

    it "doesn't clear an address if there's NOT enough money on it" do
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address, user: create(:user), balance: 0.5, target_balance: 5.5)
      expect(btc_address).not_to be_clearable

      patch :try_clearance, the_hash: btc_address.the_hash
      btc_address.reload
      expect(btc_address).not_to be_cleared
    end

    it "doesn't clear an address if it is still available to distribution" do
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address, balance: 1.5, target_balance: 1.4)
      expect(btc_address).not_to be_clearable

      patch :try_clearance, the_hash: btc_address.the_hash
      btc_address.reload
      expect(btc_address).not_to be_cleared
    end

    it "it generates a payout for the user and us" do
      btc_address = BtcAddress.create(the_hash: Faker::Bitcoin.address,user: create(:user), balance: 1.5, target_balance: 1.4)
      expect(btc_address).to be_clearable
      old_count = Payout.commission_user.payouts.count

      patch :try_clearance, the_hash: btc_address.the_hash
      btc_address.reload
      expect(Payout.commission_user.payouts.count).to eq(old_count+1)
      expect(btc_address.user.payouts).not_to be_empty
    end
  end

end
