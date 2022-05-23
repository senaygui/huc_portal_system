ActiveAdmin.register CourseRegistration do
  config.batch_actions = true
  permit_params :course_section,:enrollment_status,:course_section_id

  scoped_collection_action :scoped_collection_update, title: 'Set Section', form: -> do
                                         { 
                                            course_section_id: CourseSection.all.map { |section| [section.section_full_name, section.id] },
                                            
                                          }
                                        end

  controller do
    def scoped_collection
      super.where(academic_calendar_id: AcademicCalendar.where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first).where(semester: Semester.where("starting_date <= ? AND ending_date >= ?",Time.zone.now, Time.zone.now).order("created_at DESC").first.semester).where("enrollment_status = ?", "enrolled")
    end
  end
  index do
    selectable_column
    column :student_full_name
    column :id do |c|
      c.student.student_id
    end
    column :course_title
    column :program do |c|
      c.program.program_name
    end
    column :section_name do |c|
      c.course_section.section_short_name if c.course_section.present?
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
end
