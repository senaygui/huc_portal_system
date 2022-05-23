class StudentGrade < ApplicationRecord
  after_create :generate_assessment
  before_save :update_subtotal
  after_save :generate_grade
  ##validation

  ##assocations
    belongs_to :course_registration
    belongs_to :student
    belongs_to :course
    has_many :assessments, dependent: :destroy
  	accepts_nested_attributes_for :assessments, reject_if: :all_blank, allow_destroy: true
    has_many :grade_changes

	def assesment_total
    # assessments.collect { |oi| oi.valid? ? (oi.result) : 0 }.sum

    assessments.sum(:result)
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
  def update_subtotal
    self[:assesment_total] = assesment_total
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
