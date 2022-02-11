class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections, id: :uuid do |t|
    	t.belongs_to :course, index: true, type: :uuid
    	t.belongs_to :curriculum, index: true, type: :uuid
    	t.belongs_to :program, index: true, type: :uuid
    	t.string :section_name
    	t.integer :total_capacity
      t.timestamps
    end
  end
end
