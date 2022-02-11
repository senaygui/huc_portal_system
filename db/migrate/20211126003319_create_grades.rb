class CreateGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :grades, id: :uuid do |t|
    	t.belongs_to :grade_rule, index: true, type: :uuid
    	t.string :grade
    	t.integer :min_value
    	t.integer :max_value
    	t.integer :grade_value
      t.timestamps
    end
  end
end
