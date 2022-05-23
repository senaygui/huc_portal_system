class CourseInstractor < ApplicationRecord
	##associations
	  belongs_to :admin_user
	  belongs_to :course
	  belongs_to :academic_calendar
	  belongs_to :course_section

  ##validations
	  validates :semester, :presence => true
end
