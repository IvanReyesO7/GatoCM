class ImageDecorator
  def initialize(file)
    @img_path = file.tempfile.path
  end

  def upload_to_cloudinary
    Cloudinary::Uploader.upload(@img_path)
  end
end