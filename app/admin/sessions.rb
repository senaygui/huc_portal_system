ActiveAdmin.register Session do
  # before_action :left_sidebar!, collapsed: true

   permit_params :attendance_id,:starting_date,:ending_date,:session_title,:created_by,:updated_by,student_attendances_attributes: [:id,:student_id,:course_registration_id,:present,:absent,:remark,:created_by,:updated_by, :_destroy]

  index do
    selectable_column
    
    column :session_title
    column :attendance_title do |pd|
      pd.attendance.attendance_title
    end
    column :program do |pd|
      pd.attendance.course_section.program_name
    end
    column :course do |pd|
      pd.attendance.course_section.course_title
    end
    column "academic year", sortable: true do |n|
      link_to n.attendance.academic_calendar.calender_year, admin_academic_calendar_path(n.attendance.academic_calendar)
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end 

  form do |f|
    f.semantic_errors
    # if f.object.student_attendances.empty?
    #   f.object.student_attendances << StudentAttendance.new
    # end
    # panel "Attendance Session Information" do
    #   object.student_attendances.each do |st|

    #     f.has_many :student_attendances,heading: " ", remote: true, allow_destroy: true, new_record: false do |a|
    #       a.input :student_id, as: :text
    #       a.input :present
    #       a.input :absent
    #       a.input :remark
    #       if a.object.new_record?
    #         a.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    #       else
    #         a.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
    #       end 
    #       a.label :_destroy
    #     end
    #   end
    # end


    inputs 'Student Attendances' do
      table(class: 'form-table') do
        tr do
          th 'Student', class: 'form-table__col'
          th 'present', class: 'form-table__col'
          th 'absent', class: 'form-table__col'
          th 'remark', class: 'form-table__col'
          th 'destroy', class: 'form-table__col'
        end
        f.semantic_fields_for :student_attendances, f.object.student_attendances do |r|
          render 'rate', r: r
        end
      end
    end
    f.actions
  end

  # action_item :edit, only: :show, priority: 0 do
  #   link_to 'Add Session', edit_admin_attendance_path(attendance.id, page_name: "add")
  # end

  show title: :session_title do
    tabs do
      tab "Attendance Session Information" do
        columns do
          column max_width: "37%" do
            panel "Attendance Session Details" do
              attributes_table_for session do
                row :session_title
                row :attendance_title do |pr|
                  pr.attendance.attendance_title
                end
                row :program do |pr|
                  pr.attendance.program.program_name
                end
                row :course do |pr|
                  pr.attendance.course_title
                end
                row :course_section do |pr|
                  pr.attendance.course_section.section_short_name
                end
                row :starting_date
                row :ending_date
                row :created_by
                row :updated_by
                row :created_at
                row :updated_at
              end
            end
          end
          column min_width: "60%" do
            panel "Attendance Session" do
              table_for session.student_attendances do
                column "student",:student_full_name
                column "Student ID" do |d|
                  d.student.student_id
                end
                column :present
                column :absent
                column :remark
              end
            end 
          end 
        end
      end
    end
    
  end
end
