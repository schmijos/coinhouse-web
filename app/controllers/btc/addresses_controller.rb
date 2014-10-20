class Btc::AddressesController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :set_address, only: [:update_balance, :try_clearance]

  # POST /addresses
  def create
    # only accept empty addresses on creation
    @address = BtcAddress.new(the_hash: params[:the_hash])
    if @address.save
      render json: @address, status: :created
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /addresses/1
  def update_balance
    # here we can update an address balance
    @address.balance = params[:balance]
    if !@address.available? && @address.save # TODO availability check should belong to the model or a separate validator
      render json: @address, status: :accepted
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def needed
    count = 10 - BtcAddress.available.count # TODO magic number
    count = 0 if count < 0
    render json: count, status: :ok
  end

  def try_clearance
    # check if address balance equals order balance and then create a CHF payout
    if @address.clearable?

      # payout shop user
      customer_payout = Payout.new(
          user: @address.user,
          course_balance: @address.target_balance,
          course_unit: 'CHF')
      @address.payout = customer_payout
      @address.save

      # our payout
      our_payout = Payout.new(
          user: @address.user,
          course_balance: @address.balance - @address.target_balance,
          course_unit: 'CHF')
      Payout.commission_user.payouts << our_payout

      render json: @address, status: :accepted
    else
      render nothing: true, status: :payment_required
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = BtcAddress.find_by(the_hash: params[:the_hash])
      raise ActiveRecord::RecordNotFound.new('btc address not found') unless @address.present?
    end
end