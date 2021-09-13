class Student < ApplicationRecord
  ##callbacks
  before_save :department_assignment
  before_save :student_id_generator
  after_save :semester_registration
  # after_save :course_registration
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
  has_many :student_registrations
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
    if self.document_verification_status == "approved" && !(self.student_id.present?)
      begin
        self.student_id = "#{self.program.program_code}/#{SecureRandom.random_number(1000..10000)}/#{Time.now.strftime("%y")}"
      end while Student.where(student_id: self.student_id).exists?
    end
  end

  def semester_registration
   if self.document_verification_status == "approved" && self.student_registrations.last.nil? && self.year == 1
    StudentRegistration.create do |registration|
      registration.student_id = self.id
      registration.created_by = self.created_by
      ## TODO: find the calender of student admission type and study level
      registration.academic_calendar_id = AcademicCalendar.last.id
      registration.year = self.year
      registration.semester = self.semester
      registration.program_name = self.program.program_name
      registration.admission_type = self.admission_type
      registration.study_level = self.study_level
    end
   end 
   if self.document_verification_status == "approved" && self.year == 1
    self.program.curriculums.where(year: self.year, semester: self.semester).each do |co|
      CourseRegistration.create do |course|
        course.student_registration_id = self.student_registrations.last.id
        course.curriculum_id = co.id
      end
    end
   end
  end
  # def course_registration
  #  if self.student_registrations.last.present? && self.year == 1
  #   self.program.curriculums.where(year: self.year, semester: self.semester).each do |co|
  #     CourseRegistration.create do |course|
  #       course.student_registration_id = self.student_registrations.last.id
  #       course.curriculum_id = co.id
  #     end
  #   end
  #  end 
  # end

end
