
# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= AdminUser.new

    case user.role
    when "admin"
        can :manage, AdminUser
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Program
        can :manage, College
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
    when "finance"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Program
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :read, Department
        can :read, CourseModule
        can :read, Course
        can :read, Student
        can :manage, PaymentMethod
        can :read, AcademicCalendar
        can :manage, CollegePayment
        can :manage, SemesterRegistration
        can :manage, Invoice
    when "registrar"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Program
        #TODO: after one college created disable new action   
        # cannot :destroy, College, id: 1

        can :manage, Department
        can :manage, CourseModule
        can :manage, Course
        can :manage, Student
        can :manage, PaymentMethod
        can :manage, AcademicCalendar
        can :manage, CollegePayment
        can :manage, SemesterRegistration
        can :manage, Invoice

    when "Stock Manager"
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Product
        can :manage, Supplier
        can :manage, LocalVender
        can :manage, Catagory
        cannot :destroy, Catagory
        can :manage, Sale
        can :manage, ProductItem
        can :manage, CustomerNotification
        can :read, Customer
        can :manage, Purchase
        can :manage, PurchaseItem
        can :read, Notification, notifiable_type: "Product"
        can :read, Notification, notifiable_type: "PurchaseItem"
    when "Engineer"
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :read, Product
        can :read, Sale
        can :manage, Supplier
        can :manage, LocalVender
        can :read, Catagory
        can :manage, Customer
        can :read, Notification, notification_status: "Maintenance"
        # can :manage, Expense
        # can :manage, ActiveAdmin::Comment, resource_type: "Vacancy"
        # can :manage, ActiveAdmin::Comment, resource_type: "Order"
        # can :manage, ActiveAdmin::Comment, resource_type: "Product"
        # can :manage, ActiveAdmin::Comment, resource_type: "Advertisement"
    end
  end
end
