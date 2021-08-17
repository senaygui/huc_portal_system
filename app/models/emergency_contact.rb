class EmergencyContact < ApplicationRecord
	##validations
	  validates :full_name, :presence => true
		validates :cell_phone, :presence => true
  ##associations
  belongs_to :student
end
