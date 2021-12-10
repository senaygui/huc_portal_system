class Section < ApplicationRecord
  before_commit :set_curriculum
	belongs_to :course
	belongs_to :curriculum
	belongs_to :program

	def curriculum_id
		curriculum = Curriculum.where(program_id: self.course_id).last.id
	end

	private

	def set_curriculum
    self[:curriculum_id] = curriculum_id
  end
end
