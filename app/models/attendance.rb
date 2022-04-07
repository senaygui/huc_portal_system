class Attendance < ApplicationRecord
	before_save :attribute_assignment
  
  belongs_to :program, optional: true
  belongs_to :course_section
  belongs_to :course_breakdown
  belongs_to :academic_calendar
  has_many :sessions, dependent: :destroy
  accepts_nested_attributes_for :sessions, reject_if: :all_blank, allow_destroy: true
  
	def attribute_assignment
    self[:program_id] = self.course_breakdown.curriculum.program.id
    # self[:academic_calendar_id] = AcademicCalendar.where(admission_type: self.course_section.course_breakdown.curriculum.program.admission_type).where(study_level: self.course_section.course_breakdown.curriculum.program.study_level).last.id
    # self[:course_breakdown_id] = self.course_section.course_breakdown.id
    self[:course_title] = self.course_section.course_breakdown.course_title
  end
end
