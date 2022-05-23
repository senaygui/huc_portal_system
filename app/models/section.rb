class Section < ApplicationRecord
  
	belongs_to :program
	has_many :grade_reports
	has_many :semester_registrations
	has_many :grade_changes

	##validations
    validates :section_short_name, :presence => true
		validates :section_full_name, :presence => true, uniqueness: true
		validates :year, :presence => true
		validates :semester, :presence => true

end
