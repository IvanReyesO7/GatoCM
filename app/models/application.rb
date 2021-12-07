class Application < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id,
                                                 message: "You already have an app with that name."}
end
