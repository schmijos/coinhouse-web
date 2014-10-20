class Payout < ActiveRecord::Base
  belongs_to :user
  has_many :btc_addresses

  def self.commission_user
    User.find 1
  end

  def complete?
    completed_at.present? && completed_at.past?
  end
end
