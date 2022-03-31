ActiveAdmin.register Invoice do
  permit_params :semester_registration_id,:invoice_number,:total_price,:registration_fee,:late_registration_fee,:penalty,:daily_penalty,:invoice_status,:last_updated_by,:created_by,:due_date,payment_transaction_attributes: [:id,:invoice_id,:payment_method_id,:account_holder_fullname,:phone_number,:account_number,:transaction_reference,:finance_approval_status,:last_updated_by,:created_by, :receipt_image], inovice_item_ids: []


  index do
    selectable_column
    column "invoice no",:invoice_number
    column "student", sortable: true do |n|
      n.semester_registration.student.name.full 
    end
    column "admission type", sortable: true do |n|
      n.semester_registration.admission_type 
    end
    column "study level", sortable: true do |n|
      n.semester_registration.study_level 
    end
    column :invoice_status do |s|
      status_tag s.invoice_status
    end
    number_column :total_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
    
    # column :mode_of_payment
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  scope :recently_added
  scope :pending
  scope :approved
  scope :denied
  scope :incomplete
  # scope :undergraduate
  # scope :graduate
  # scope :online
  # scope :regular
  # scope :extention
  # scope :distance

  form do |f|
    f.semantic_errors
    f.inputs 'payment transaction', for: [:payment_transaction, f.object.payment_transaction || PaymentTransaction.new] do |a|
      ## TODO: find way to hide the payment_transaction form if student fill it them self
      if f.object.new_record?
        a.input :payment_method_id, as: :search_select, url: admin_payment_methods_path,
            fields: [:bank_name, :id], display_name: 'bank_name', minimum_input_length: 2,
            order_by: 'id_asc'
        a.input :account_holder_fullname
        a.input :phone_number
        a.input :account_number
        a.input :transaction_reference
        a.input :receipt_image, as: :file
      end
      a.input :finance_approval_status, as: :select, :collection => ["pending", "approved", "re-submit", "denied", "under submitted"], :include_blank => false
      if a.object.new_record?
        a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end 
    end
    f.inputs "invoice status" do
      f.input :invoice_status, as: :select, :collection => ["pending", "approved", "re-submit", "denied", "under submitted"], :include_blank => false
    end
    f.actions
  end

  show :title => proc{|invoice| "Invoice ##{invoice.invoice_number}" } do
    
    columns do
      column do
        panel "invoice summery" do
          attributes_table_for invoice do
            row :invoice_number
            row "registration academic year" do |s|
              link_to s.semester_registration.academic_calendar.calender_year, admin_semester_registration_path(s.semester_registration.id)
            end
            row :invoice_status do |s|
              status_tag s.invoice_status
            end
            
            row "payment mode", sortable: true do |n|
              n.semester_registration.mode_of_payment
            end
            row :due_date if invoice.due_date.present?
            number_row :registration_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 if invoice.registration_fee > 0
            number_row :late_registration_fee, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 if invoice.late_registration_fee > 0 
            # number_row :penalty, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 if invoice.penalty > 0 
            # number_row :daily_penalty, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2 if invoice.daily_penalty > 0 
            number_row :total_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Sender Information" do
          attributes_table_for invoice.payment_transaction do
            row "account name" do |a|
              a.account_holder_fullname
            end 
            row :account_number 
            row :phone_number 
            row "payment method" do |pr|
              link_to pr.payment_method.bank_name, admin_payment_method_path(pr.payment_method.id)
            end
            # row "payment type" do |pr|
            #   pr.payment_method.payment_method_type
            # end
            row "reference no." do |pr|
              pr.transaction_reference
            end
            row "attachement" do |pr|
              link_to "attachement", rails_blob_path(pr.receipt_image, disposition: 'preview')
            end
            row "finance approval" do |s|
              status_tag s.finance_approval_status
            end
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "Student Information" do
          attributes_table_for invoice.semester_registration do
            row "Student name", sortable: true do |n|
              n.student.name.full 
            end
            row "student ID" do |s|
              s.student.student_id
            end
            row "Prorgam", sortable: true do |d|
              link_to d.student.program.program_name, [:admin, d.student.program]
            end
            row "admission type", sortable: true do |n|
              n.admission_type 
            end
            row "study level", sortable: true do |n|
              n.study_level 
            end
            row "year", sortable: true do |n|
              n.year 
            end
            row "semester", sortable: true do |n|
              n.student.semester 
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Invoice Item Information" do
          table_for invoice.invoice_items do
            column "Course title" do |pr|
              link_to pr.course_registration.course_breakdown.course.course_title, admin_course_path(pr.course_registration.course_breakdown.course.id)
            end
            column "Course code" do |pr|
              pr.course_registration.course_breakdown.course.course_code
            end
            column "Course module" do |pr|
              link_to pr.course_registration.course_breakdown.course.course_module.module_code, admin_course_module_path(pr.course_registration.course_breakdown.course.course_module.id) 
            end
            column "Credit hour" do |pr|
              pr.course_registration.course_breakdown.credit_hour
            end
            number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: ",", precision: 2
          end
        end
      end
    end
    
    
  end 
  
end
