class CourseRegistration < ApplicationRecord
  belongs_to :student_registration
  belongs_to :curriculum
end
