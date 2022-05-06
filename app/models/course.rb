class Course < ApplicationRecord
	before_save :attribute_assignment
	
	#validations
    validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :lecture_hour, :presence => true
		validates :ects, :presence => true
		validates :course_code, :presence => true
  ##associations
  	belongs_to :course_module
  	belongs_to :curriculum
  	belongs_to :program, optional: true
 		# has_many :programs, through: :curriculums, dependent: :destroy
 		has_many :student_grades, dependent: :destroy
 		has_many :sections

 		has_many :student_courses, dependent: :destroy
 		has_many :assessments
	  has_many :course_registrations, dependent: :destroy
	  has_many :course_sections, dependent: :destroy
	  has_many :attendances, dependent: :destroy
	  has_many :assessment_plans, dependent: :destroy
		has_one_attached :course_outline, dependent: :destroy
		accepts_nested_attributes_for :assessment_plans, reject_if: :all_blank, allow_destroy: true
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}


  private

  def attribute_assignment
    self[:program_id] = self.curriculum.program.id
  end
end
