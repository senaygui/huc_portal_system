class Collage < ApplicationRecord
	##validations
    validates :collage_name , :presence => true,:length => { :within => 2..100 }

  ##associations
  has_many :departments
end
