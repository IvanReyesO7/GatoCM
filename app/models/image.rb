class Image < ApplicationRecord
  belongs_to :application

  before_create :generate_name_fomat
  after_save :create_component

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
