class Invoice < ApplicationRecord
	after_create :add_invoice_item
	after_update :update_total_price
	##validations
    validates :invoice_number , :presence => true
  ##associations
	  belongs_to :student_registration
	  has_one :payment_transaction
	  accepts_nested_attributes_for :payment_transaction, reject_if: :all_blank, allow_destroy: true
	  has_many :invoice_items
	##scope
    scope :recently_added, lambda {where('created_at >= ?', 1.week.ago)}
    # scope :undergraduate, lambda { self.student_registration.where(study_level: "undergraduate")}
    # scope :graduate, lambda { self.student_registration.where(study_level: "graduate")}
    # scope :online, lambda { self.student_registration.where(admission_type: "online")}
    # scope :regular, lambda { self.student_registration.where(admission_type: "regular")}
    # scope :extention, lambda { self.student_registration.where(admission_type: "extention")}
    # scope :distance, lambda { self.student_registration.where(admission_type: "distance")}
    scope :pending, lambda { where(invoice_status: "pending")}
    scope :approved, lambda { where(invoice_status: "approved")}
    scope :denied, lambda { where(invoice_status: "denied")}
    scope :incomplete, lambda { where(invoice_status: "incomplete")}

	def total_price
    self.invoice_items.collect { |oi| oi.valid? ? (CollagePayment.where(study_level: self.student_registration.study_level,admission_type: self.student_registration.admission_type).first.registration_fee * oi.course_registration.curriculum.credit_hour) : 0 }.sum + self.registration_fee
  end
  
  private

  	def add_invoice_item
			self.student_registration.course_registrations.each do |course|
				InvoiceItem.create do |invoice_item|
					invoice_item.invoice_id = self.id
					invoice_item.course_registration_id = course.id
					invoice_item.created_by = self.created_by
					if self.student_registration.mode_of_payment == "monthly"
						course_price =  CollagePayment.where(study_level: self.student_registration.study_level,admission_type: self.student_registration.admission_type).first.tution_per_credit_hr * course.curriculum.credit_hour / 4
					elsif self.student_registration.mode_of_payment == "full"
						course_price =  CollagePayment.where(study_level: self.student_registration.study_level,admission_type: self.student_registration.admission_type).first.tution_per_credit_hr * course.curriculum.credit_hour
					elsif self.student_registration.mode_of_payment == "half"
						course_price =  CollagePayment.where(study_level: self.student_registration.study_level,admission_type: self.student_registration.admission_type).first.tution_per_credit_hr * course.curriculum.credit_hour / 2
					end
					invoice_item.price = course_price
				end
			end
		end
	  def update_total_price
	    self[:total_price] = total_price
	  end
end
