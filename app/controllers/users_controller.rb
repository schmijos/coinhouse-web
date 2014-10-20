class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:iframe]

  # GET /users/1/iframe
  def iframe
    @next_address = BtcAddress.available.first
    raise ActiveRecord::RecordNotFound.new('no btc address available') unless @next_address.present?
    @next_address.user = @user
    @next_address.target_balance = 1
    @next_address.target_course_balance = 450
    @next_address.target_course_unit = 'CHF'
    @next_address.valid_until = 2.minutes.from_now
    @next_address.save

		# max 136 Bytes input see: http://www.qrcode.com/en/about/version.html TODO: do something about it
		@qrcode = RQRCode::QRCode.new(@next_address.the_hash, :size => 6, :level => :l)

		render layout: false
  end

  # GET /users/1/payouts
  def payouts
    render json: "lol"
  end

end
