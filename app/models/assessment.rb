class Assessment < ApplicationRecord
	##associations
		belongs_to :student_grade
		belongs_to :student, optional: true
		belongs_to :course , optional: true
		belongs_to :assessment_plan, optional: true
		has_many :grade_changes
		has_many :makeup_exams
end
