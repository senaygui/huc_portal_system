class PagesController < ApplicationController
	before_action :authenticate_student!
  def home

  end
  def documents
  end

  def dashboard
  	@address = current_student.student_address
  	@emergency_contact = current_student.emergency_contact
  end
end
