class User < ActiveRecord::Base
  has_many :btc_addresses
  has_many :payouts

  validates_presence_of :name, :email, :encrypted_password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
