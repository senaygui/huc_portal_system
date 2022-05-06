class Department < ApplicationRecord
  ##validations
  validates :department_name , :presence => true,:length => { :within => 2..200 }
  ##associations
  belongs_to :faculty
  has_many :programs, dependent: :destroy
  has_many :course_modules, dependent: :destroy
  has_many :grade_reports
end
