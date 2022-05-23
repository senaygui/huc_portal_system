class CreateCourseInstractors < ActiveRecord::Migration[5.2]
  def change
    create_table :course_instractors do |t|
      t.belongs_to :admin_user, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.belongs_to :course_section, index: true, type: :uuid
      t.integer :semester
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
