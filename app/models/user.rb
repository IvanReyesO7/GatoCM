class User < ApplicationRecord
  has_many :applications
  has_many :lists, through: :applications
  has_many :images, through: :applications
  has_many :codes, through: :applications
  has_many :components, through: :applications

  before_validation :generate_api_token
  validates :api_token, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  extend Blacklist
  validates :username, exclusion: { in: blacklist, message: "The username you choose is invalid, please try again." }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  private 
  def generate_api_token
    self.api_token = SecureRandom.hex(24)
  end

  def to_param
    username
  end
end
