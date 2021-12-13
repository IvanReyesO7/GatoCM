class List < ApplicationRecord
  belongs_to :application
  has_many :items
  before_create :generate_name_fomat
  validates :name, presence: true, uniqueness: { scope: :application_id,
                                                 case_sensitive: true,
                                                 message: "You already have a list in this app with that name."}


  def generate_name_fomat
    self.name_format = self.name.downcase.gsub(" ","_")
  end 
end
