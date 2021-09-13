class CourseRegistration < ApplicationRecord
	after_create :add_invoice_item
	##associations
	  belongs_to :student_registration
	  belongs_to :curriculum
	  has_many :invoice_items


	private
		def add_invoice_item
			if (self.student_registration.semester == 1) && (self.student_registration.year == 1) && self.student_registration.mode_of_payment.present? && self.student_registration.invoice.last.nil?
				InvoiceItem.create do |invoice_item|
					invoice_item.invoice_id = self.student_registration.invoice.id
					invoice_item.course_registration_id = self.id

					if self.student_registration.mode_of_payment == "monthly"
						course_price =  CollagePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour / 4
					elsif self.student_registration.mode_of_payment == "full"
						course_price =  CollagePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour
					elsif self.student_registration.mode_of_payment == "half"
						course_price =  CollagePayment.where(study_level: self.study_level,admission_type: self.admission_type).first.tution_per_credit_hr * self.curriculum.credit_hour / 2
					end
					invoice_item.price = course_price
				end
			end
		end
end
