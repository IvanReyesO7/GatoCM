class Code < ApplicationRecord
  belongs_to :application
  
  before_create :generate_name_fomat
  after_create :create_component

  validates :title, presence: true, uniqueness: { scope: :application_id,
                                                  case_sensitive: true,
                                                  message: "You already have a piece of code in this app with that title."}
  validates :content, presence: true

  def generate_name_fomat
    self.name_format = self.title.downcase.gsub(" ","_")
  end 

  def create_component
    Component.new.tap do |comp|
      comp.real_component_type = self.class
      comp.real_component_id = self.id
      comp.real_component_title = self.title
      comp.application = self.application
      comp.save!
    end
  end
end
