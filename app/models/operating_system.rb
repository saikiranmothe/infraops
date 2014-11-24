class OperatingSystem < ActiveRecord::Base

  # Validations
  validates :name, presence: true
  validates :short_name, presence: true

  # Associations
  has_many :versions
  has_one :picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::DepartmentPicture"

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> department.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(name) LIKE LOWER('%#{query}%') OR LOWER(short_name) LIKE LOWER('%#{query}%') OR LOWER(description) LIKE LOWER('%#{query}%')")}

end
