ActiveAdmin.register Course do
  menu priority: 7
  
permit_params :course_module_id,:curriculum_id,:program_id,:course_title,:course_code,:course_description,:year,:semester,:course_starting_date,:course_ending_date,:credit_hour,:lecture_hour,:lab_hour,:ects,:created_by,:last_updated_by, assessment_plans_attributes: [:id,:course_id,:assessment_title,:assessment_weight, :created_by, :updated_by, :_destroy]

  index do
    selectable_column
    column :course_title
    column :course_code
    column :module_title, sortable: true do |m|
     link_to m.course_module.module_title, [:admin, m.course_module]
    end
    column :program, sortable: true do |m|
     link_to m.program.program_name, [:admin, m.program]
    end
    column :curriculum, sortable: true do |m|
     link_to m.curriculum.curriculum_version, [:admin, m.curriculum]
    end
    column :credit_hour
    column :created_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :course_title
  filter :course_code 
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
         fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
         order_by: 'created_at_asc' 
  filter :curriculum_id, as: :search_select_filter, url: proc { admin_curriculums_path },
         fields: [:curriculum_version, :id], display_name: 'curriculum_version', minimum_input_length: 1,
         order_by: 'created_at_asc' 
  filter :course_module_id, as: :search_select_filter, url: proc { admin_course_modules_path },
         fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
         order_by: 'module_code_asc' 
  
  filter :course_title
  filter :course_code
  filter :course_description
  filter :year
  filter :semester
  filter :course_starting_date
  filter :course_ending_date
  filter :credit_hour
  filter :lecture_hour
  filter :lab_hour
  filter :ects
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  
  form do |f|
    f.semantic_errors
    if !(params[:page_name] == "add_assessment")
      f.inputs "Course information" do
        f.input :course_title
        f.input :course_code
        f.input :course_description,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
        f.input :course_module_id, as: :search_select, url: admin_course_modules_path,
            fields: [:module_title, :id], display_name: 'module_title', minimum_input_length: 2,
            order_by: 'id_asc'
        f.input :program_id, as: :search_select, url: proc { admin_programs_path },
           fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
           order_by: 'created_at_asc' 
        f.input :curriculum_id, as: :search_select, url: proc { admin_curriculums_path },
           fields: [:curriculum_version, :id], display_name: 'curriculum_version', minimum_input_length: 1,
           order_by: 'created_at_asc'
        f.input :credit_hour, :required => true, min: 1, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
        f.input :lecture_hour
        f.input :lab_hour
        f.input :ects
        f.input :year, as: :select, :collection => [1, 2,3,4,5,6,7], :include_blank => false
        f.input :semester, as: :select, :collection => [1, 2,3,4], :include_blank => false
        f.input :course_starting_date, as: :date_time_picker 
        f.input :course_ending_date, as: :date_time_picker
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end      
      end
    elsif params[:page_name] == "add_assessment"
      if f.object.assessment_plans.empty?
        f.object.assessment_plans << AssessmentPlan.new
      end
      panel "Assessment Plans" do
        f.has_many :assessment_plans,heading: " ", remote: true, allow_destroy: true, new_record: true do |a|
          a.input :assessment_title
          a.input :assessment_weight,:input_html => { :min => 1, :max => 100  } 

          if f.object.new_record?
            a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
          else
            a.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full} 
          end 
        end
      end
    end
    f.actions
  end
  action_item :edit, only: :show, priority: 1  do
    link_to 'Add Assessment Plan', edit_admin_course_path(course.id, page_name: "add_assessment")
  end

  show title: :course_title do
    tabs do
      tab "Course Information" do
        panel "Course information" do
          attributes_table_for course do
            row :course_title
            row :course_code
            row "module title" do |d|
              link_to d.course_module.module_title, admin_course_module_path(d.course_module.id)
            end
            row :program do |m|
             link_to m.program.program_name, [:admin, m.program]
            end
            row :curriculum_version do |m|
             link_to m.curriculum.curriculum_version, [:admin, m.curriculum]
            end
            row :course_description
            row :credit_hour
            row :lecture_hour
            row :lab_hour
            row :ects
            row :year
            row :semester
            row :course_starting_date
            row :course_ending_date
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      tab "Course section" do
      end
      tab "currently enrolled students" do
      end
      tab "Assessment Plan" do
        columns do
          column min_width: "70%" do
            panel "Assessment Plan Information" do
              table_for course.assessment_plans.order('created_at ASC') do
                column  :assessment_title
                column  :assessment_weight
                column "Added At", sortable: true do |c|
                  c.created_at.strftime("%b %d, %Y")
                end
                column "Updated At", sortable: true do |c|
                  c.updated_at.strftime("%b %d, %Y")
                end
                
                column  :created_by
                column  :updated_by 
                column "links", sortable: true do |c|
                    "#{link_to("View", admin_assessment_plan_path(c))} #{link_to "Edit", edit_admin_course_path(course.id, page_name: "add_assessment")}".html_safe     
                end
              end
            end
          end
          column max_width: "27%" do
            panel "Assessment Plan Summery" do 
              attributes_table_for course do
                row :total_assesement do |s|
                  s.assessment_plans.count
                end
                row :total_assesement_weight do |s|
                  s.assessment_plans.pluck(:assessment_weight).sum
                end
              end
            end
          end
        end  
      end
      tab "Course Enrollement Report" do
      end
    end
  end 
  # sidebar "program belongs to", :only => :show do
  #   table_for course.course_breakdowns do

  #     column "program" do |c|
  #       link_to c.program.program_name, admin_program_path(c.program.id)
  #     end
  #   end
  # end 
end
