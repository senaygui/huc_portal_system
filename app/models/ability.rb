
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
        can :manage, Collage
        #TODO: after one collage created disable new action   
        cannot :destroy, Collage, id: 1

        can :manage, Department
        can :manage, CourseModule
        can :manage, Course
        can :manage, Student
        can :manage, PaymentMethod
        can :manage, AcademicCalendar
        can :manage, CollagePayment
    when "General Manager"
        can :manage, ActiveAdmin
        can :manage, AdminUser
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        # can :manage, ActiveAdmin::Comment
        can :manage, Product
        can :manage, Catagory
        cannot :destroy, Catagory
        can :manage, Sale
        can :manage, Supplier
        can :manage, Customer
        can :manage, CustomerNotification
        can :manage, LocalVender
        can :manage, Account
        can :read, Notification
        can :destroy, Notification
        can :manage, Purchase
        can :manage, PurchaseItem
        can :manage, ProductItem
        # can :manage, Expense
    when "Sales"
        can :manage, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        can :manage, Sale
        can :manage, CustomerNotification
        can :manage, Customer

        can :read, Product
        can :read, Catagory
        can :read, Supplier
        can :read, LocalVender
        can :read, Notification, notifiable_type: "Sale"
        can :read, PurchaseItem
        can :manage, ProductItem

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
