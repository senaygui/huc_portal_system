class Curriculum < ApplicationRecord

	##validations
    validates :curriculum_title, :presence => true
		validates :curriculum_version, :presence => true, uniqueness: true
		validates :curriculum_active_date, :presence => true
	##associations
	  belongs_to :program
	  has_many :course_breakdowns, dependent: :destroy
	  
	  accepts_nested_attributes_for :course_breakdowns, reject_if: :all_blank, allow_destroy: true
end
