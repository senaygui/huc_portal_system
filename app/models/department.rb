class Department < ApplicationRecord
  ##validations
  validates :department_name , :presence => true,:length => { :within => 2..200 }
  ##associations
  belongs_to :faculty
  has_many :programs, dependent: :destroy
  has_many :student_grades
  has_many :course_modules, dependent: :destroy
  has_many :grade_reports, dependent: :destroy
  has_many :grade_changes, dependent: :destroy
  has_many :semester_registrations, dependent: :destroy
  has_many :course_registrations, dependent: :destroy
  has_many :admin_users
end
