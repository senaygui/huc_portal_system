class MakeupExam < ApplicationRecord
	# after_save :current_grade
	after_save :generate_invoice_for_makeup_exam
	##validations
		validates :year, :presence => true 
		validates :semester, :presence => true 
		validates :previous_result_total, :presence => true 
		validates :previous_letter_grade, :presence => true 
		validates :reason, :presence => true 
	##associations
	  belongs_to :course
	  belongs_to :program, optional: true
	  belongs_to :department, optional: true
	  belongs_to :section, optional: true
	  belongs_to :academic_calendar
	  belongs_to :student
	  belongs_to :course_registration, optional: true
		belongs_to :student_grade, optional: true
		belongs_to :assessment
		has_one :other_payment, as: :payable, dependent: :destroy

	private

	# def current_grade
	# 	if (self.department_approval == "approved") && (self.registrar_approval == "approved") && (self.dean_approval == "approved") && (self.instructor_approval== "approved") && (self.academic_affair_approval== "approved")
	#   	self.assessment.update_columns(result: self.add_mark)
	#   	self.assessment.touch
	#   	self.student_grade.update_columns(assesment_total: self.student_grade.assessments.sum(:result))
	#   	self.student_grade.touch

	#   	grade_in_letter = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.student_grade.assesment_total).where("max_row_mark >= ?", self.student_grade.assesment_total).last.letter_grade
 #      grade_letter_value = self.student.program.grade_systems.last.grades.where("min_row_mark <= ?", self.student_grade.assesment_total).where("max_row_mark >= ?", self.student_grade.assesment_total).last.grade_point
	  			
 #      self.student_grade.update_columns(letter_grade: grade_in_letter)
 #      self.student_grade.update_columns(grade_point: grade_letter_value)

	#   	self.update_columns(current_result_total: self.student_grade.assesment_total)
	#   	self.update_columns(current_letter_grade: grade_in_letter)
	#   end
	# end

	def generate_invoice_for_makeup_exam
		if (self.department_approval == "approved") && (self.registrar_approval == "approved") && (self.dean_approval == "approved") && (self.instructor_approval== "approved") && (self.academic_affair_approval== "approved") && (!self.other_payment.present?)
			OtherPayment.create do |invoice|
				invoice.student_id = self.student.id
				invoice.academic_calendar_id = self.academic_calendar_id
				invoice.semester_registration_id = self.course_registration.semester_registration_id
				invoice.department_id = self.department_id
				invoice.program_id = self.program_id
				invoice.section_id = self.section_id
				invoice.payable_type = "MakeupExam"
				invoice.payment_type = "Makeup Exam"
				invoice.payable_id = self.id
				invoice.year = self.year
				invoice.semester = self.semester
				invoice.student_id_number = self.student.student_id
				invoice.student_full_name = self.course_registration.student_full_name
				invoice.created_by = "system"
				invoice.due_date = Time.now + 10.day
				invoice.invoice_status = "unpaid"
				invoice.invoice_number = SecureRandom.random_number(10000000)
				invoice.total_price =  CollegePayment.where(study_level: self.student.study_level,admission_type: self.student.admission_type).first.makeup_exam_fee      
			end
		end
	end
end
