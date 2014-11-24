class Image::Base < ActiveRecord::Base

  self.table_name = "images"

  # Associations
  belongs_to :imageable, :polymorphic => true
  
  mount_uploader :image, ImageUploader
  
end
