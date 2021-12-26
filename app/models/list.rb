class List < ApplicationRecord
  belongs_to :application
  has_many :items

  before_create :generate_name_fomat
  after_create :create_component

  validates :name, presence: true, uniqueness: { scope: :application_id,
                                                 case_sensitive: true,
                                                 message: "You already have a list in this app with that name."}


  def generate_name_fomat
    self.name_format = self.name.downcase.gsub(" ","_")
  end 

  def create_component
    Component.new.tap do |comp|
      comp.real_component_type = self.class
      comp.real_component_id = self.id
      comp.real_component_title = self.name
      comp.application = self.application
      comp.save!
    end
  end
end
