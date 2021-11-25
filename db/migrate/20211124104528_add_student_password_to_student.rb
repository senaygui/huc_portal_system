class AddStudentPasswordToStudent < ActiveRecord::Migration[5.2]
  def change
  	add_column :students, :student_password, :string
  end
end
