class CreateBtcAddresses < ActiveRecord::Migration
  def change
    create_table :btc_addresses do |t|
      t.string :the_hash, unique: true, null: false
      t.float :balance, default: 0, null: false

      t.references :user, index: true
      t.references :payout, index: true

      t.float :target_balance
      t.float :target_course_balance
      t.string :target_course_unit
      t.timestamp :valid_until

      t.timestamps
    end
  end
end
