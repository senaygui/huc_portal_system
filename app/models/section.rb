class Section < ApplicationRecord
  before_commit :set_curriculum
	belongs_to :course
	belongs_to :curriculum
	belongs_to :program
	has_many :grade_reports

	def curriculum_id
		curriculum = Curriculum.where(program_id: self.course_id).last.id
	end

	private

	def set_curriculum
    self[:curriculum_id] = curriculum_id
  end
end
