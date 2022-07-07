class Transfer < ApplicationRecord
	##validations
		validates :semester, presence: true
		validates :year, presence: true
	##assocations
	  belongs_to :student
	  belongs_to :program
	  belongs_to :section
	  belongs_to :department
	  belongs_to :academic_calendar
end
