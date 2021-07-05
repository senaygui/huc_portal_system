class Department < ApplicationRecord
  ##validations
  validates :collage_name , :presence => true,:length => { :within => 2..100 }
  ##associations
  belongs_to :collage
end
