class Session < ApplicationRecord
	after_create :add_student_attendance
	
  belongs_to :attendance
  # belongs_to :academic_calendar
  has_many :student_attendances
  accepts_nested_attributes_for :student_attendances, reject_if: :all_blank, allow_destroy: true

  # def attribute_assignment
  #   # self[:program_id] = self.course_section.course_breakdown.curriculum.program.id
  #   self[:academic_calendar_id] = self.attendance.academic_calendar.id
  #   # self[:course_breakdown_id] = self.course_section.course_breakdown.id
  #   # self[:course_title] = self.course_section.course_breakdown.course_title
  # end

  private
    def add_student_attendance
      self.attendance.course_section.course_registrations.where(academic_calendar_id: attendance.academic_calendar.id).each do |co|
        StudentAttendance.create do |item|
          item.course_registration_id = self.id
          item.session_id = self.id
          item.student_id = co.student_id
          item.student_full_name = co.student_full_name
          item.course_registration_id = co.id
          item.created_by = self.attendance.created_by
        end
      end
    end
  end
