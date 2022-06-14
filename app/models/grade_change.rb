class GradeChange < ApplicationRecord

	after_save :current_grade

	##validations
		validates :semester, :presence => true 
		validates :previous_result_total, :presence => true 
		validates :previous_letter_grade, :presence => true 
		validates :reason, :presence => true 
	##associations
	  belongs_to :course
	  belongs_to :program
	  belongs_to :department
	  belongs_to :section
	  belongs_to :academic_calendar
	  # belongs_to :course_section, optional: true
	  belongs_to :student
	  belongs_to :course_registration
		belongs_to :student_grade
		belongs_to :assessment


		private

			def current_grade
				if (self.department_approval == "approved") && (self.registrar_approval == "approved") && (self.dean_approval == "approved") && (self.instructor_approval == "approved") && (self.academic_affair_approval== "approved")
	  			self.assessment.update_columns(result: self.add_mark)
	  			self.assessment.touch
	  			self.student_grade.update_columns(assesment_total: self.student_grade.assessments.sum(:result))
	  			self.student_grade.touch

	  			grade_in_letter = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.student_grade.assesment_total).where("max_row_mark >= ?", self.student_grade.assesment_total).last.letter_grade
      		grade_letter_value = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.student_grade.assesment_total).where("max_row_mark >= ?", self.student_grade.assesment_total).last.grade_point
	  			
      		self.student_grade.update_columns(letter_grade: grade_in_letter)
      		self.student_grade.update_columns(grade_point: grade_letter_value)

	  			self.update_columns(current_result_total: self.student_grade.assesment_total)
	  			self.update_columns(current_letter_grade: grade_in_letter)
	  		end
			end
end
