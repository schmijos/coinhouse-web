class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.float :course_balance, default: 0
      t.string :course_unit
      t.references :user, index: true

      t.timestamp :completed_at
      t.timestamps
    end
  end
end
