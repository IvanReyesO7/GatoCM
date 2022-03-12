class FileDecorator
  attr_reader :name, :content, :type
  
  def initialize(uploaded_file)
    @path = uploaded_file.tempfile.path
    @name = uploaded_file.original_filename
    @content_type = uploaded_file.content_type
    @file = File.open(@path)
    @type = detect_type
    @content = @file.read
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
end
