class Student < ApplicationRecord
  ##callbacks
  before_save :department_assignment
  before_save :student_id_generator
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_person_name    
  ##associations
  belongs_to :program
  has_one :student_address, dependent: :destroy
  accepts_nested_attributes_for :student_address
  has_one :emergency_contact, dependent: :destroy
  accepts_nested_attributes_for :emergency_contact
  has_many_attached :documents
  has_one_attached :photo
     
  ##validations
  validates :first_name , :presence => true,:length => { :within => 2..100 }
  validates :last_name , :presence => true,:length => { :within => 2..100 }
  validates :student_id , uniqueness: true
  validates	:gender, :presence => true
	validates	:date_of_birth , :presence => true
	validates	:study_level, :presence => true
  validates :admission_type, :presence => true,:length => { :within => 2..10 }
  validates :photo,
            content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg']
  validates :documents, attached: true
  
  ##scope
    scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
    scope :undergraduate, lambda { where(study_level: "undergraduate")}
    scope :graduate, lambda { where(study_level: "graduate")}
    scope :online, lambda { where(admission_type: "online")}
    scope :regular, lambda { where(admission_type: "regular")}
    scope :extention, lambda { where(admission_type: "extention")}
    scope :distance, lambda { where(admission_type: "distance")}
    scope :pending, lambda { where(document_verification_status: "pending")}
    scope :approved, lambda { where(document_verification_status: "approved")}
    scope :denied, lambda { where(document_verification_status: "denied")}
    scope :incomplete, lambda { where(document_verification_status: "incomplete")}

  private
  ## callback methods
  def department_assignment
    self[:department] = program.department.department_name
  end
  def student_id_generator
    if self.document_verification_status == "approved" && self.student_id.empty?
      begin
        self.student_id = "#{self.program.program_code}/#{SecureRandom.random_number(1000..10000)}/#{Time.now.strftime("%y")}"
      end while Student.where(student_id: self.student_id).exists?
    end
  end

end
