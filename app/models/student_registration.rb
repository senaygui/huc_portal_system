class StudentRegistration < ApplicationRecord
	after_create :student_information
	##validations
	  validates :semester, :presence => true
		validates :year, :presence => true
	##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :undergraduate, lambda { where(study_level: "undergraduate")}
  	scope :graduate, lambda { where(study_level: "graduate")}
  	scope :online, lambda { where(admission_type: "online")}
  	scope :regular, lambda { where(admission_type: "regular")}
  	scope :extention, lambda { where(admission_type: "extention")}
  	scope :distance, lambda { where(admission_type: "distance")}
	##associations
	  belongs_to :student
	  belongs_to :academic_calendar
	  has_many :course_registrations, dependent: :destroy
  	has_many :curriculums, through: :course_registrations, dependent: :destroy
  	# accepts_nested_attributes_for :course_registrations, reject_if: :all_blank, allow_destroy: true

  	private
	  	def student_information
	  		self[:admission_type] = self.student.admission_type
	  		self[:study_level] = self.student.study_level
	  		self[:program_name] = self.student.program.program_name
	  	end
end
