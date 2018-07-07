class Image < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  before_save :update_image_attributes

  private

  def update_image_attributes
    if image.present? && image_changed?
      self.content_type = image.file.content_type
      self.file_size = image.file.size
      self.file_name = image.file.original_filename
    end
  end
end
