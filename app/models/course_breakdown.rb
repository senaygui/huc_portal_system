class CourseBreakdown < ApplicationRecord
	before_save :course_title_assign

	##validations
    validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :lecture_hour, :presence => true
		validates :ects, :presence => true
		validates :course_code, :presence => true
	##associations
	  belongs_to :course
	  belongs_to :curriculum
	  # has_many :course_registrations, dependent: :destroy

	private

  def course_title_assign
  	self[:course_title] = self.course.course_title
  end
end
