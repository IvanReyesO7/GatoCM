class FileDecorator
  attr_reader :name, :content, :type, :extension

  def initialize(uploaded_file)
    path = uploaded_file.tempfile.path
    file = File.open(path)
    @name = uploaded_file.original_filename
    @content_type = uploaded_file.content_type
    @type = detect_type
    @content = file.read
    @extension = generate_extension(@type)
  end

  def detect_type
    case @content_type
    when "text/x-ruby-script"
      return "ruby"
    when "text/javascript"
      return "javascript"
    when "text/x-python-script"
      return "python"
    when "text/html"
      return "html"
    when "text/css"
      return "css"
    else
      raise StandardError.new("File type not supported")
    end 
  end

  def generate_extension(type)
    case type
    when 'ruby'
      return '.rb'
    when 'javascript'
      return '.js'
    when 'python'
      return '.py'
    when 'html'
      return '.html'
    when 'css'
      return 'css'
    end
  end
end
