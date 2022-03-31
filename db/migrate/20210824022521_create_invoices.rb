class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices, id: :uuid do |t|
      t.belongs_to :semester_registration, index: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :academic_calendar, index: true, type: :uuid
      t.string :student_name
      t.string :department
      t.string :program
      t.string :student_full_name
      t.string :student_id_number
      t.string :invoice_number, null: false
      t.decimal :total_price
      t.decimal :registration_fee, default: 0
			t.decimal :late_registration_fee, default: 0
			t.string :invoice_status , default: "not submitted"
			t.string :last_updated_by
      t.string :created_by
      t.datetime :due_date
      t.timestamps
    end
  end
end
