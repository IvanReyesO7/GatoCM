class ReadToken < ApplicationRecord
  belongs_to :application
  after_initialize :generate_read_token

  validates :name, presence: true, uniqueness: { scope: :application_id,
                                                 message: "You already have a token with that name."}

  def generate_read_token
    self.token = SecureRandom.hex(12)
  end
end
