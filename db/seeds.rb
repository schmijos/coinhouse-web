# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "create free bitcoin addresses"
free_btc_addresses = BtcAddress.create([
                                      {the_hash: "hashashashash1"},
                                      {the_hash: "hashashashash2"},
                                      {the_hash: "hashashashash3"},
                                      {the_hash: "hashashashash4"},
                                      {the_hash: "hashashashash5"}
                                  ])

puts "create some users, addresses and payouts"
["sadi", "raplh", "soko"].each do |name|
  user = User.create(name: name, email: name + '@example.com', password: '1234')
  user.confirm!
  10.times do
    btc_balance_sample = 1.fdiv(rand(1..100))
    time_sample = rand(1..10).days.ago
    user.btc_addresses << BtcAddress.create(
        the_hash:              "hash_" + name + "_" + btc_balance_sample.to_s,
        balance:               [btc_balance_sample, btc_balance_sample, btc_balance_sample, 0].sample,
        target_balance:        btc_balance_sample,
        target_course_balance: btc_balance_sample * 500,
        target_course_unit:    'USD',
        created_at:            time_sample,
        valid_until:           time_sample + 3.minutes)
  end

  [*1..10].each do |some|
    time_range = some.days.ago.beginning_of_day..some.days.ago.end_of_day
    grouped_addresses = user.btc_addresses.ready_to_payout.where(created_at: time_range)
    payout = Payout.create(
        course_balance: grouped_addresses.sum(:target_course_balance) * 0.91,
        course_unit: 'CHF',
        user: user)
    payout.btc_addresses << grouped_addresses
  end
end
