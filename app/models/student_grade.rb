class StudentGrade < ApplicationRecord
  after_create :generate_assessment
  after_save :update_subtotal
  after_save :generate_grade
  after_save :add_course_registration
  ##validation

  ##assocations
    belongs_to :course_registration, optional: true
    belongs_to :student
    belongs_to :course
    belongs_to :department
    belongs_to :program
    has_many :assessments, dependent: :destroy
  	accepts_nested_attributes_for :assessments, reject_if: :all_blank, allow_destroy: true
    has_many :grade_changes
    has_many :makeup_exams

  def add_course_registration
    cr = CourseRegistration.where(student_id: self.student.id, course_id: self.course.id).last.id
    self.update_columns(course_registration_id: cr)
  end
	# def assesment_total
 #    # assessments.collect { |oi| oi.valid? ? (oi.result) : 0 }.sum

 #    assessments.sum(:result)
 #  end
  def update_subtotal
    self.update_columns(assesment_total: self.assessments.sum(:result))
  end
  def generate_grade
    if assessments.where(result: nil).empty?
      grade_in_letter = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.assesment_total).where("max_row_mark >= ?", self.assesment_total).last.letter_grade
      grade_letter_value = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.assesment_total).where("max_row_mark >= ?", self.assesment_total).last.grade_point
    	self.update_columns(letter_grade: grade_in_letter)
      self.update_columns(grade_point: grade_letter_value)
    elsif assessments.where(result: nil)
      self.update_columns(letter_grade: "I")
      # needs to be empty and after a week changes to f
      self.update_columns(grade_point: 0)
    end
  	# self[:grade_in_letter] = grade_in_letter
  end

	private

  

  def generate_assessment
    self.course.assessment_plans.each do |plan|
      Assessment.create do |assessment|
        assessment.course_id = self.course.id
        assessment.student_id = self.student.id
        assessment.student_grade_id = self.id
        assessment.assessment_plan_id = plan.id
        assessment.created_by = self.created_by
      end
    end
  end
end
