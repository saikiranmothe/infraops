class OsVersion < ActiveRecord::Base

  # Validations

  validates :name, presence: true
  validates :version, presence: true

  # Associations
  belongs_to :operating_system

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> designation.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(version) LIKE LOWER('%#{query}%') OR LOWER(description) LIKE LOWER('%#{query}%')")}

end
