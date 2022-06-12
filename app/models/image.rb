class Image < ApplicationRecord
  belongs_to :application
  before_create :generate_name_fomat
  after_create :create_component
  
  validates :title, presence: true, uniqueness: { scope: :application_id,
                                                  case_sensitive: true,
                                                  message: "You already have an image in this app with that title."}
  validates :url, presence: true
  validates :public_id, presence: true

  def generate_name_fomat
    self.name_format = self.title.downcase.gsub(/[\s|\.]/,"_")
  end 

  def display_name
    if title.length > 15
      title.slice(0..9) + '..'
    else
      title
    end
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

  def increase_download_count!
    self.downloads += 1
    self.save
  end
end
