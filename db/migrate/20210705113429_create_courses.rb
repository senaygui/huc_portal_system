class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses, id: :uuid do |t|
      t.belongs_to :course_module, index: true, type: :uuid
      t.string :course_title, null: false
      t.string :course_code, null: false
      t.text :course_description

      ##created and updated by
      t.string :created_by
      t.string :last_updated_by

      t.timestamps
    end
  end
end
