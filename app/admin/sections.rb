ActiveAdmin.register Section do

  permit_params :program_id,:course_id,:curriculum_id,:section_name,:total_capacity

  index do
    selectable_column
    column "Course" do |c|
      c.course.course_title
    end
    column :section_name
    column :total_capacity
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end 

  form do |f|
    f.semantic_errors
    f.inputs "Section information" do
      f.input :section_name
      f.input :program_id, as: :search_select, url: admin_programs_path,
            fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
            order_by: 'id_asc'
      f.input :course_id, as: :search_select, url: admin_courses_path,
            fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
            order_by: 'id_asc'
      f.input :total_capacity 
      f.input :curriculum_id, as: :hidden, :input_html => { :value => 1}
   
    end
    f.actions
  end
end
