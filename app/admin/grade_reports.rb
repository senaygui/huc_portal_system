ActiveAdmin.register GradeReport do

permit_params :semester_registration_id,:student_id,:academic_calendar_id,:program_id,:department_id,:section_id,:admission_type,:study_level,:total_course,:total_credit_hour,:total_grade_point,:cumulative_total_credit_hour,:cumulative_total_grade_point,:cgpa,:sgpa,:semester,:year,:academic_status,:registrar_approval,:registrar_name,:dean_approval,:dean_name,:department_approval,:department_head_name,:updated_by,:created_by

  index do
    selectable_column
    column "Student Name", sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
    end
    column "Student ID", sortable: true do |n|
      n.student.student_id
    end
    column :program, sortable: true do |pro|
      pro.program.program_name
    end
    column :department, sortable: true do |pro|
      pro.department.department_name
    end
    # column :admission_type
    # column :study_level
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column "Year, Semester", sortable: true do |n|
      "Year #{n.year}, Semester #{n.semester}"
    end
    column "SGPA",:sgpa
    column "CGPA",:cgpa
    column "Issue Date", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  # filter :admission_type
  # filter :study_level   
  # filter :min_cgpa_value_to_pass
  # filter :created_at
  # filter :updated_at


  
  form :title => "Grade Report Approval" do |f|
    f.semantic_errors
    f.inputs "Grade Report Approval" do
      if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
        f.input :department_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
        f.input :department_head_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      elsif (current_admin_user.role == "regular_registrar") || (current_admin_user.role == "extention_registrar") || (current_admin_user.role == "online_registrar") || (current_admin_user.role == "distance_registrar") || (current_admin_user.role == "admin")
        f.input :registrar_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
        f.input :registrar_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      elsif (current_admin_user.role == "dean") || (current_admin_user.role == "admin")
        f.input :dean_approval, as: :select, :collection => ["pending","approved", "denied"], :include_blank => false
        f.input :dean_name, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end 

      if !f.object.new_record?
        f.input :updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}    
      end
    end 
    f.actions
  end

  show title: "Grade Report" do
    columns do
      column max_width: "30%" do
        panel "Grade Report Information" do
          attributes_table_for grade_report do
            row "Student Name" do |n|
              link_to "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}", admin_student_path(n.student)
            end
            row "Student ID" do |n|
              n.student.student_id
            end
            row :program do |pro|
              pro.program.program_name
            end
            row :department do |pro|
              pro.department.department_name
            end
            row "Faculty" do |pro|
              pro.department.faculty.faculty_name
            end
            row "Academic Year" do |n|
              link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
            end
            row "Year, Semester" do |n|
              "Year #{n.year}, Semester #{n.semester}"
            end
            row :dean_approval do |s|
              status_tag s.dean_approval
            end
            row :department_approval do |s|
              status_tag s.department_approval
            end
            row :registrar_approval do |s|
              status_tag s.registrar_approval
            end
            row "Issue Date", sortable: true do |c|
              c.created_at.strftime("%b %d, %Y")
            end
          end
        end
      end
      column min_width: "67%" do
        panel "Course Registration" do
          table_for grade_report.semester_registration.course_registrations do
            column "Course title" do |pr|
              link_to pr.course_title, admin_course_path(pr.course)
            end
            column "Course code" do |pr|
              pr.course.course_code
            end
            column "Course module" do |pr|
              link_to pr.course.course_module.module_code, admin_course_module_path(pr.course.course_module.id) 
            end
            column "Credit hour" do |pr|
              pr.course.credit_hour
            end
            column "Letter Grade" do |pr|
              pr.student_grade.letter_grade
            end
            column "Grade Point" do |pr|
              pr.student_grade.grade_point
            end
          end
        end
        panel "report" do
          table(class: 'form-table') do
            tr do
              th '  ', class: 'form-table__col'
              th 'Cr Hrs', class: 'form-table__col'
              th 'Grade Point', class: 'form-table__col'
              th 'Average (GPA)', class: 'form-table__col'
            end
            tr class: "form-table__row" do
              th 'Current Semester Total', class: 'form-table__col'
              td "#{grade_report.total_credit_hour}", class: 'form-table__col'
              td "#{grade_report.total_grade_point}", class: 'form-table__col'
              td "#{grade_report.sgpa}", class: 'form-table__col'
            end
            tr class: "form-table__row" do
              th 'Previous Total', class: 'form-table__col'
              if grade_report.student.grade_reports.count > 1
                td "#{grade_report.student.grade_reports.last.total_credit_hour}", class: 'form-table__col'
                td "#{grade_report.student.grade_reports.last.total_grade_point}", class: 'form-table__col'
                td "#{grade_report.student.grade_reports.last.cgpa}", class: 'form-table__col'
              end
            end
            tr class: "form-table__row" do
              th 'Cumulative', class: 'form-table__col'
              td "#{grade_report.cumulative_total_credit_hour}", class: 'form-table__col'
              td "#{grade_report.cumulative_total_grade_point}", class: 'form-table__col'
              td "#{grade_report.cgpa}", class: 'form-table__col'
            end
          end
        end
      end
    end  
  end 
  
end
