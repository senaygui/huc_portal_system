class CreateCourseRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :course_registrations, id: :uuid do |t|
      t.belongs_to :semester_registration, index: true, type: :uuid
      t.belongs_to :curriculum, index: true, type: :uuid
      t.string :enrollment_status, default:"pending"
      t.string :course_title
      t.timestamps
    end
  end
end
