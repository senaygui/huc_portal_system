ActiveAdmin.register CourseSection do

  permit_params :program_name, :section_short_name,:section_full_name,:course_id,:course_title,:total_capacity,:created_by,:updated_by, course_registrations: []

  index do
    selectable_column
    column "Course" do |c|
      c.course.course_title
    end
    column :program_name
    column :section_short_name
    column :total_capacity
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end 

  form do |f|
    f.semantic_errors
    if !(params[:page_name] == "enroll")
      f.inputs "Section information" do
        f.input :section_short_name
        f.input :section_full_name
        f.input :course_id, as: :search_select, url: admin_courses_path,
              fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
              order_by: 'id_asc'
        f.input :total_capacity 
        if f.object.new_record?
          f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        else
          f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
        end 
        
      end
    else
      if !f.object.new_record?
        f.inputs "Enrolled Students" do
          f.input :course_registrations, :as => :check_boxes, :collection => CourseRegistration.where(course_id: course_section.course).all.order("student_full_name ASC").pluck(:student_full_name, :id)
        end
      end
    end
    f.actions
  end

  action_item :edit, only: :show, priority: 0 do
    link_to 'Enroll Student', edit_admin_course_section_path(course_section.id, page_name: "enroll")
  end

  show title: :section_short_name do
    columns do
      column do
        panel "course section information" do
          attributes_table_for course_section do
            row :section_short_name
            row :section_full_name
            row :program_name
            row :course_title
            row :total_capacity
            row :created_by
            row :updated_by
            row :created_at
            row :updated_at
          end
        end
      end
      column do
        panel "course section report" do
          table_for AcademicCalendar.where(study_level: course_section.course.program.study_level, admission_type: course_section.course.curriculum.program.admission_type) do
              column "Academic calendar" do |item|
                link_to item.calender_year, admin_course_registrations_path(:q => { :course_title_eq => "#{course_section.course_title}", academic_calendar_id_eq: item.id })

              end
              column "Enrolled Students" do |item|
                course_section.course_registrations.where(academic_calendar_id: item.id).count
              end 
              column "Asign section", sortable: true do |item|
                link_to "Asign", admin_course_registrations_path(:q => { :course_id_eq => "#{course_section.course.id}", academic_calendar_id_eq: item.id })  
              end 
          end
        end 
      end 
    end
    columns do
      column do
        panel "Currently enrolled students" do
          table_for course_section.course_registrations do
            column "Student Full Name" do |n|
              link_to n.student_full_name, admin_student_path(n.student)
            end
            column "Student ID" do |n|
              n.student.student_id
            end
            column "Academic calendar" do |n|
              n.academic_calendar.calender_year
            end
            column "Year" do |n|
              n.semester_registration.year
            end
            column "Semester" do |n|
              n.semester_registration.semester
            end
            #TODO: add a remove btn first create a member action the delete section id from course registration
            # column "Remove" do |n|
            #   link_to 'Destroy', admin_course_registrations_path(n), data: {:confirm => 'Are you sure?'}, :method => :delete 
            # end
          end
        end 
      end
    end
    
  end

end
