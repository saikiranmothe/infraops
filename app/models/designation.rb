class Designation < ActiveRecord::Base
  
  # Validations

  validates :title, presence: true
  validates :responsibilities, presence: true
  
  # Associations
  has_many :users
  has_one :picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::DesignationPicture"
  
  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> designation.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(designations.title) LIKE LOWER('%#{query}%') OR LOWER(designations.responsibilities) LIKE LOWER('%#{query}%')")}
  
end
