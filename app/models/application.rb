class Application < ApplicationRecord
  belongs_to :user
  has_many :lists
  has_many :images
  has_many :codes 
  has_many :components
  validates :name, presence: true, uniqueness: { scope: :user_id,
                                                 message: "You already have an app with that name."}
end
