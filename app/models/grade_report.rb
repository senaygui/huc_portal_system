class GradeReport < ApplicationRecord

	##validations
  	validates :admission_type, :presence => true
		validates :study_level, :presence => true
		validates :total_course, :presence => true
		validates :total_credit_hour, :presence => true
		validates :total_grade_point, :presence => true
		validates :cumulative_total_credit_hour, :presence => true
		validates :cumulative_total_grade_point, :presence => true
		validates :cgpa, :presence => true
		validates :sgpa, :presence => true
		validates :semester, :presence => true
		validates :year, :presence => true
		validates :academic_status, :presence => true
  ##associations
  	belongs_to :department
	  belongs_to :semester_registration
	  belongs_to :student
	  belongs_to :academic_calendar
	  belongs_to :program
	  belongs_to :section, optional: true


	 def update_grade_report
	 	if (self.semester_registration.course_registrations.joins(:student_grade).pluck(:letter_grade).include?("I") == false) && (self.academic_status == "Incomplete")
	 		if self.student.grade_reports.count == 1
		 		total_credit_hour = self.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| oi.valid? ? (oi.course.credit_hour) : 0 }.sum 
		 		self.update_columns(total_credit_hour: total_credit_hour)
				total_grade_point = self.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| oi.valid? ? (oi.course.credit_hour * oi.student_grade.grade_point) : 0 }.sum 
				self.update_columns(total_grade_point: total_grade_point)
				sgpa = (total_grade_point / total_credit_hour)
				self.update_columns(sgpa: sgpa)
				cumulative_total_credit_hour = total_credit_hour
				self.update_columns(cumulative_total_credit_hour: cumulative_total_credit_hour)
				cumulative_total_grade_point = total_grade_point
				self.update_columns(cumulative_total_grade_point: cumulative_total_grade_point)
				cgpa = (cumulative_total_grade_point / cumulative_total_credit_hour)
				self.update_columns(cgpa: cgpa)
				academic_status = self.program.grade_systems.last.academic_statuses.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
				self.update_columns(academic_status: academic_status)
				if academic_status != "Dismissal"
					if self.program.program_semester > self.student.semester
						promoted_semester = self.student.semester + 1
						self.student.update_columns(semester: promoted_semester)
					elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
						promoted_year = self.student.year + 1
						self.student.update_columns(semester: 1)
						self.student.update_columns(year: promoted_year)
					end
				end
			else
				total_credit_hour = self.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| oi.valid? ? (oi.course.credit_hour) : 0 }.sum 
		 		self.update_columns(total_credit_hour: total_credit_hour)
				total_grade_point = self.semester_registration.course_registrations.where(enrollment_status: "enrolled").collect { |oi| oi.valid? ? (oi.course.credit_hour * oi.student_grade.grade_point) : 0 }.sum 
				self.update_columns(total_grade_point: total_grade_point)
				sgpa = (total_grade_point / total_credit_hour)
				self.update_columns(sgpa: sgpa)
				cumulative_total_credit_hour = GradeReport.where(student_id: self.student_id).order("created_at ASC").last.cumulative_total_credit_hour + total_credit_hour
				self.update_columns(cumulative_total_credit_hour: cumulative_total_credit_hour)
				cumulative_total_grade_point = GradeReport.where(student_id: self.student_id).order("created_at ASC").last.cumulative_total_grade_point + total_grade_point
				self.update_columns(cumulative_total_grade_point: cumulative_total_grade_point)
				cgpa = (cumulative_total_grade_point / cumulative_total_credit_hour)
				self.update_columns(cgpa: cgpa)
				academic_status = self.program.grade_systems.last.academic_statuses.where("min_value <= ?", cgpa).where("max_value >= ?", cgpa).last.status
				self.update_columns(academic_status: academic_status)
				if academic_status != "Dismissal"
					if self.program.program_semester > self.student.semester
						promoted_semester = self.student.semester + 1
						self.student.update_columns(semester: promoted_semester)
					elsif (self.program.program_semester == self.student.semester) && (self.program.program_duration > self.student.year)
						promoted_year = self.student.year + 1
						self.student.update_columns(semester: 1)
						self.student.update_columns(year: promoted_year)
					end
				end
			end
	 	end
	 end
end
