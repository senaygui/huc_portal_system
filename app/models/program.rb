class Program < ApplicationRecord
	##validations
    validates :program_name , :presence => true,:length => { :within => 2..50 }
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
end
