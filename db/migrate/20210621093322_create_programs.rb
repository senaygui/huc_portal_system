class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
    	t.belongs_to :department, index: true
    	t.string :program_name, null:false
    	t.string :study_level, null: false
    	t.string :admission_type, null: false
    	t.text :overview
    	t.text :program_description
    	t.integer :program_duration
      t.decimal :total_tuition, default: 0.0
    	t.string :created_by
    	t.string :last_updated_by
      t.timestamps
    end
  end
end
