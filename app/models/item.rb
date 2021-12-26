class Item < ApplicationRecord
  belongs_to :list

  validates :content, presence: {message: "Item cannot be blank"}
end
