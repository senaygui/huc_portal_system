class Section < ApplicationRecord
  
	belongs_to :program
	has_many :grade_reports
	has_many :semester_registrations
	has_many :course_registrations
	has_many :grade_changes
	has_many :course_instractors
	has_many :attendances, dependent: :destroy
	has_many :withdrawals
	##scope
    scope :instractor_courses, -> (user_id) {CourseInstractor.where(admin_user_id: user_id).pluck(:section_id)}
    scope :instractors, -> (user_id) {CourseInstractor.where(section_id: instractor_courses(user_id)).pluck(:course_id)}

	##validations
    validates :section_short_name, :presence => true
		validates :section_full_name, :presence => true, uniqueness: true
		validates :year, :presence => true
		validates :semester, :presence => true

end
