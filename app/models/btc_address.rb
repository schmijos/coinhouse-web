class BtcAddress < ActiveRecord::Base
  belongs_to :user
  belongs_to :payout

  # a hash can only used once
  validates :the_hash, uniqueness: true
  validates :the_hash, format: { with: /\A(1|3)[a-zA-Z1-9]{26,33}\z/, message: "invalid bitcoin address" }

  # free addresses can be given to users
  scope :available, -> { where(user: nil) }
  scope :paid, -> { where("target_balance <= balance") }
  scope :ready_to_payout, -> { paid.where(payout: nil) }
  scope :cleared, -> { paid.where.not(user: nil).where.not(payout: nil) }

  def available?
    BtcAddress.available.exists?(id)
  end

  def paid?
    BtcAddress.paid.exists?(id)
  end

  def cleared?
    BtcAddress.cleared.exists?(id)
  end

  def clearable?
    user.present? && paid?
  end

  def ready_to_payout?
    BtcAddress.ready_to_payout.exists?(id)
  end

  def to_s
    the_hash
  end

end
