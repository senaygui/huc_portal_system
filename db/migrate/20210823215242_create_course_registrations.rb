class CreateCourseRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :course_registrations, id: :uuid do |t|
    	t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :semester_registration, index: true, type: :uuid
      t.belongs_to :course_breakdown, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.string :student_full_name
      t.string :enrollment_status, default:"pending"
      t.string :course_title
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
