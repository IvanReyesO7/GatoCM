class List < ApplicationRecord
  belongs_to :application
  validates :name, presence: true, uniqueness: { scope: :application_id,
                                                 message: "You already have an list in this app with that name."}
end
