class Code < ApplicationRecord
  belongs_to :application
  
  before_create :generate_name_fomat
  after_create :create_component

  validates :title, presence: true, uniqueness: { scope: :application_id,
                                                  case_sensitive: true,
                                                  message: "You already have a piece of code in this app with that title."}
  validates :content, presence: true
  validates :file_type, presence: true

  def generate_name_fomat
    self.name_format = self.title.downcase.gsub(/[\s|\.]/,"_")
  end 

  def icon_source
    case file_type
    when 'ruby'
      return "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ruby/ruby-original.svg"
    when 'javascript'
      return "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg"
    when 'python'
      return "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg"
    when 'html'
      return "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg"
    when 'css'
      return "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg"
    else
      return "https://i.pinimg.com/564x/d0/78/22/d078228e50c848f289e39872dcadf49d.jpg"
    end 
  end

  def display_name
    if title.length > 15
      title.slice(0..9) + '..' + extension
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
end
