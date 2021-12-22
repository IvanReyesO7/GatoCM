class Code < ApplicationRecord
  belongs_to :application
  after_save :create_component

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
