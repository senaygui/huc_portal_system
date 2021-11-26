ActiveAdmin.register StudentGrade do

  permit_params :course_registration_id,:student_id,:grade_in_letter,:grade_in_number,:course_id,assessments_attributes: [:id,:assessment,:result, :_destroy]


  member_action :generate_grade, method: :put do
    @student_grade= StudentGrade.find(params[:id])
    @student_grade.generate_grade
    redirect_back(fallback_location: admin_student_grade_path)
  end
  action_item :update, only: :show do
    link_to 'generate grade', generate_grade_admin_student_grade_path(student_grade.id), method: :put, data: { confirm: 'Are you sure?' }        
  end
  index do
    selectable_column
    column "full name", sortable: true do |n|
      n.student.name.full 
    end
    column "Student ID" do |si|
      si.student.student_id
    end
    column "Course title" do |si|
      si.course.course_title
    end
    column :grade_in_letter
    column :grade_in_number
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :grade_in_letter
  filter :grade_in_number
  filter :created_at
  filter :updated_at


  
  form do |f|
    f.semantic_errors

    if f.object.assessments.empty?
      f.object.assessments << Assessment.new
    end
    panel "Assessment" do
      f.has_many :assessments,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
        a.input :assessment
        a.input :result
        a.label :_destroy
      end
    end
    f.actions
  end

  show :title => proc{|student| student.student.name.full } do
    panel "Grade information" do
      attributes_table_for student_grade do
        row "full name", sortable: true do |n|
          n.student.name.full 
        end
        row "Student ID" do |si|
          si.student.student_id
        end
        row "Course title" do |si|
          si.course.course_title
        end
        row "Program" do |pr|
          link_to pr.student.program.program_name, admin_program_path(pr.student.program.id)
        end
        row :grade_in_letter
        row :grade_in_number
        row :created_at
        row :updated_at
      end
    end
    panel "Assessments Information" do
      table_for student_grade.assessments do
        column :assessment
        column :result
        column :created_at
        column :updated_at
      end
    end
  end 
  
end