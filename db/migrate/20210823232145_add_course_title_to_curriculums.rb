class AddCourseTitleToCurriculums < ActiveRecord::Migration[5.2]
  def change
  	add_column :curriculums, :course_title, :string
  end
end
