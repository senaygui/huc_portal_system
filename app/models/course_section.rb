class CourseSection < ApplicationRecord
	before_save :course_title_assign

	##validations
    validates :section_short_name, :presence => true
		validates :section_full_name, :presence => true, uniqueness: true
		
	##associations
  	belongs_to :course_breakdown
  	has_many :course_registrations
  	has_many :attendances, dependent: :destroy
  private

  def course_title_assign
  	self[:course_title] = self.course_breakdown.course_title
    self[:section_full_name] = "#{self.section_short_name} - #{self.course_title}"
    self[:program_name] = self.course_breakdown.curriculum.program.program_name
  end
end
