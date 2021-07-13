class Curriculum < ApplicationRecord
	##validations
    validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :full_course_price, :presence => true
	##associations
	  belongs_to :program
	  belongs_to :course
end
