class List < ApplicationRecord
  belongs_to :application
  has_many :items
  validates :name, presence: true, uniqueness: { scope: :application_id,
                                                 message: "You already have a list in this app with that name."}
end
