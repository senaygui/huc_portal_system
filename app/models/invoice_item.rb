class InvoiceItem < ApplicationRecord
  ##associations
	  belongs_to :itemable, polymorphic: true
	  belongs_to :course_registration, optional: true
end
