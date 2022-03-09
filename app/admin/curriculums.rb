ActiveAdmin.register Curriculum do

 menu priority: 6
 permit_params :curriculum_title,:curriculum_version,:total_course,:total_ects,:total_credit_hour,:active_status,:curriculum_active_date,:depreciation_date,:created_by,:last_updated_by, course_breakdowns_attributes: [:id,:course_id,:curriculum_id,:semester,:course_starting_date,:course_ending_date,:year,:credit_hour,:lecture_hour,:lab_hour,:ects,:course_code,:course_title,:created_by,:last_updated_by, :_destroy]

 index do
  selectable_column
  column :curriculum_title
  column  "Version",:curriculum_version
  column "Program", sortable: true do |d|
    link_to d.program.program_name, [:admin, d.program]
  end
  column "Courses",:total_course
  column "Credit hours",:total_credit_hour
  column "ECTS",:total_ects
  column :active_status do |s|
    status_tag s.active_status
  end
  column "Add At", sortable: true do |c|
    c.created_at.strftime("%b %d, %Y")
  end
  actions
end

filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
order_by: 'id_asc'
filter :curriculum_title
filter :curriculum_version
filter :total_course
filter :total_ects
filter :total_credit_hour
filter :active_status
filter :curriculum_active_date
filter :depreciation_date
filter :created_by
filter :last_updated_by

filter :created_at
filter :updated_at

# scope :recently_added

form do |f|
  f.semantic_errors
  f.inputs "Curriculum information" do
    f.input :program_id, as: :search_select, url: admin_programs_path,
    fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
    order_by: 'id_asc'
    f.input :curriculum_title
    f.input :curriculum_version
    f.input :total_course
    f.input :total_ects
    f.input :total_credit_hour
    f.input :curriculum_active_date, as: :date_time_picker 

    if f.object.new_record?
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    else
      f.input :active_status, as: :select, :collection => ["active","depreciated"]
      f.input :depreciation_date, as: :date_time_picker
      f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    end      
  end
  if f.object.course_breakdowns.empty?
    f.object.course_breakdowns << CourseBreakdown.new
  end
  panel "Course Breakdown Information" do
    f.has_many :course_breakdowns,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
      a.input :course_id, as: :search_select, url: admin_courses_path,
      fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
      order_by: 'id_asc'
      a.input :course_code
      a.input :credit_hour, :required => true, min: 1, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
      a.input :lecture_hour
      a.input :lab_hour
      a.input :ects
      a.input :year, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
      a.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
      a.input :course_starting_date, as: :date_time_picker 
      a.input :course_ending_date, as: :date_time_picker



      if a.object.new_record?
        a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end 
      a.label :_destroy
    end
  end
  f.actions
end

show title: :curriculum_title do
  tabs do
    tab "Curriculum information" do
      panel "Curriculum information" do
        attributes_table_for curriculum do
          row :program_name do |pr|
            link_to pr.program.program_name, admin_programs_path(pr.program)
          end
          row :curriculum_title
          row :curriculum_version
          row :total_course
          row :total_ects
          row :total_credit_hour
          row :active_status
          row :curriculum_active_date
          row :depreciation_date
          row :created_by
          row :last_updated_by

          row :created_at
          row :updated_at
        end
      end
    end
    tab "Course Breakdown" do      
      panel "Course Breakdown list" do
        (1..curriculum.program.program_duration).map do |i|
          panel "ClassYear: Year #{i}" do
            (1..curriculum.program.program_semester).map do |s|
              panel "Semester: #{s}" do
                table_for curriculum.course_breakdowns.where(year: i, semester: s).order('year ASC','semester ASC') do
                  ## TODO: wordwrap titles and long texts
                  
                  column "course title" do |item|
                    link_to item.course.course_title, [ :admin, item.course] 
                  end
                  column "module code" do |item|
                    item.course.course_module.module_code
                  end
                  column "course code" do |item|
                    item.course_code
                  end
                  column "credit hour" do |item|
                    item.credit_hour
                  end
                  column :lecture_hour do |item|
                    item.lecture_hour
                  end
                  column :lab_hour do |item|
                    item.lab_hour
                  end
                  column "ECTS" do |item|
                    item.ects
                  end
                  column :created_by
                  column :last_updated_by
                  column "Starts at", sortable: true do |c|
                    c.course_starting_date.strftime("%b %d, %Y") if c.course_starting_date.present?
                  end
                  column "ends At", sortable: true do |c|
                    c.course_ending_date.strftime("%b %d, %Y") if c.course_ending_date.present?
                  end
                end
              end
            end      
          end 
        end    
      end 
    end
  end


end

end
