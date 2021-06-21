class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
    	t.string :program_name, null:false
    	t.string :description
    	t.string :created_by
    	t.string :last_updated_by
      t.timestamps
    end
  end
end
