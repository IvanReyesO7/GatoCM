class ImageDecorator
  attr_reader :extension

  def initialize(file)
    @img_path = file.tempfile.path
    @content_type = file.content_type
    @extension = detect_extension
  end

  def detect_extension
    case @content_type
    when "image/png"
      return "png"
    when "image/jpeg"
      return "jpeg"
    when "image/jpg"
      return "jpg"
    end
  end

  def upload_to_cloudinary
    Cloudinary::Uploader.upload(@img_path)
  end
end
