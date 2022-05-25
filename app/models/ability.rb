
# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= AdminUser.new

    case user.role
    when "admin"
        can :manage, GradeSystem
        can :manage, GradeChange        
        can :manage, AssessmentPlan
        can :manage, CourseRegistration
        can :manage, Attendance
        can :manage, Session
        # can :manage, CourseSection
        can :read, StudentGrade
        can :update, StudentGrade
        can :destroy, StudentGrade
        cannot :create, StudentGrade
        can :manage, GradeReport
        # can :manage, GradeRule
        can :manage, Grade
        can :manage, AdminUser
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Program
        can :manage, College
        can :manage, Faculty
        can :manage, Curriculum
        #TODO: after one college created disable new action   
        cannot :destroy, College, id: 1

        can :manage, Department
        can :manage, CourseModule
        can :manage, Course
        can :manage, Student
        can :manage, PaymentMethod
        can :manage, AcademicCalendar
        can :manage, CollegePayment
        can :manage, SemesterRegistration
        can :manage, Invoice
        can :manage, Section
        can :manage, Almuni
    when "instractor"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, AcademicCalendar
        can :read, Course, id: Course.instractor_courses(user.id)
        can :update, Course, id: Course.instractor_courses(user.id)
        can :read, AssessmentPlan, course_id: Course.instractor_courses(user.id)
        can :read, CourseRegistration, section_id: Section.instractor_courses(user.id)
        can :manage, StudentGrade, course_id: Section.instractors(user.id)
        cannot :destroy, StudentGrade
        can :manage, Assessment
        can :read, Attendance, section_id: Section.instractor_courses(user.id)
        can :update, Attendance, section_id: Section.instractor_courses(user.id)

        can :create, Session
        can :read, Session, course_id: Section.instractors(user.id)
        can :update, Session, course_id: Section.instractors(user.id)
        cannot :destroy, Session, course_id: Section.instractors(user.id)

        can :read, GradeChange, course_id: Section.instractors(user.id)
        can :update, GradeChange , course_id: Section.instractors(user.id)
    when "finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student
        can :manage, PaymentMethod
        can :read, AcademicCalendar
        can :manage, CollegePayment
        can :read, SemesterRegistration
        can :manage, Invoice
    when "registrar head"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, AcademicCalendar
        can :manage, AdminUser, role: "instractor"
        can :manage, Faculty
        can :manage, Department
        can :read, CourseModule
        can :read, Program
        can :read, Curriculum
        can :read, Course
        can [:update, :read], GradeSystem
        can :read, AssessmentPlan
        can :manage, Section
        can :manage, Student
        can :manage, SemesterRegistration
        can :manage, CourseRegistration
        can :read, CollegePayment
        can :read, PaymentMethod
        can :read, Invoice
        can :manage, Attendance
        can :manage, Session

        cannot [:create, :read], GradeReport
        cannot :destroy, GradeReport
        can :read, StudentGrade
        can :manage, GradeChange
    when "distance_registrar"
        can :manage, CourseSection
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Student, admission_type: "distance"
        can :read, Program, admission_type: "distance"
        can :read, AcademicCalendar, admission_type: "distance"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "distance"
        can :read, Invoice
    when "online_registrar"
        can :manage, CourseSection
        can :read, StudentGrade
        can :read, GradeReport
        can :read, GradeRule
        can :read, Grade
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Student, admission_type: "online"
        can :read, Program, admission_type: "online"
        can :read, AcademicCalendar, admission_type: "online"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "online"
        can :read, Invoice
    when "regular_registrar"
        can :manage, CourseSection
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, AcademicCalendar, admission_type: "regular"
        can :manage, Student, admission_type: "regular"
        can :read, Program, admission_type: "regular"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "regular"
        can :read, Invoice 
    when "extention_registrar"
        can :manage, CourseSection
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Student, admission_type: "extention"
        can :read, AcademicCalendar, admission_type: "extention"
        can :read, Program, admission_type: "extention"
        can :manage, Department
        can :read, CourseModule
        can :read, Course
        can :manage, SemesterRegistration, admission_type: "extention"
        can :read, Invoice 
    when "regular_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "regular"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "regular"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "regular"
        can :manage, CollegePayment, admission_type: "regular"
        can :read, SemesterRegistration, admission_type: "regular"
        can :manage, Invoice
    when "distance_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "distance"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "distance"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "distance"
        can :manage, CollegePayment, admission_type: "distance"
        can :read, SemesterRegistration, admission_type: "distance"
        can :manage, Invoice
    when "online_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "online"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "online"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "online"
        can :manage, CollegePayment, admission_type: "online"
        can :read, SemesterRegistration, admission_type: "online"
        can :manage, Invoice
    when "extention_finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Program, admission_type: "extention"
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student, admission_type: "extention"
        can :manage, PaymentMethod
        can :read, AcademicCalendar, admission_type: "extention"
        can :manage, CollegePayment, admission_type: "extention"
        can :read, SemesterRegistration, admission_type: "extention"
        can :manage, Invoice        
    when "department head"
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Department, department_id: user.department.id
        can :manage, CourseModule, department_id: user.department.id
        can :manage, Course, course_module: {department_id: user.department.id}
        can :manage, AdminUser, role: "instractor"
        can :manage, Program, department_id: user.department.id
        can :manage, Curriculum, program: {department_id: user.department.id}
        can :manage, GradeSystem, program: {department_id: user.department.id}
        can :manage, AssessmentPlan, course: {program: {department_id: user.department.id}}
        can :read, AcademicCalendar
        can :read, Section, program: {department_id: user.department.id}
        can :read, Student, department: user.department.department_name
        can :read, CourseRegistration, department_id: user.department.id
        can :read, SemesterRegistration, department_id: user.department.id
        can :read, Attendance, program: {department_id: user.department.id}
        can :read, Session, course: {program: {department_id: user.department.id}}
        can :read, StudentGrade, department_id: user.department.id
        can [:read, :update], GradeChange, department_id: user.department.id
        can [:read, :update], GradeReport, department_id: user.department.id  
    end
  end
end
