class CreateCourseRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :course_registrations do |t|
      t.belongs_to :student_registration, index: true
      t.belongs_to :curriculum, index: true
      t.string :enrollment_status, default:"pending"
      t.timestamps
    end
  end
end
