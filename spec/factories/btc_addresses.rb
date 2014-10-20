require 'securerandom'

FactoryGirl.define do
  factory :btc_address do
    the_hash { Faker::Bitcoin.address }
  end
end