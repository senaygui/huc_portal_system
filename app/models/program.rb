class Program < ApplicationRecord
  before_save :update_subtotal
  

	##validations
    validates :program_name , :presence => true,:length => { :within => 2..50 }
    validates :study_level , :presence => true
    validates :admission_type , :presence => true
    validates :program_duration , :presence => true
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :undergraduate, lambda { where(study_level: "undergraduate")}
  	scope :graduate, lambda { where(study_level: "graduate")}
  	scope :online, lambda { where(admission_type: "online")}
  	scope :regular, lambda { where(admission_type: "regular")}
  	scope :extention, lambda { where(admission_type: "extention")}
  	scope :distance, lambda { where(admission_type: "distance")}
  ##associations
    belongs_to :department
    has_many :curriculums
    has_many :courses, through: :curriculums, dependent: :destroy
    accepts_nested_attributes_for :curriculums, reject_if: :all_blank, allow_destroy: true
  
  def total_tuition
    curriculums.collect { |oi| oi.valid? ? (oi.full_course_price) : 0 }.sum
  end
  private

  def update_subtotal
    self[:total_tuition] = total_tuition
  end
end
