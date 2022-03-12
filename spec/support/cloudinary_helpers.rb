module CloudinaryHelpers
  def self.clean(image)
    Cloudinary::Uploader.destroy(image.public_id)
  end
end