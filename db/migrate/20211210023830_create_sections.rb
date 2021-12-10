class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
    	t.belongs_to :course, index: true
    	t.belongs_to :curriculum, index: true
    	t.belongs_to :program, index: true
    	t.string :section_name
    	t.integer :total_capacity
      t.timestamps
    end
  end
end
