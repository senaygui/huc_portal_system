ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation,:first_name,:last_name,:middle_name,:role,:username

  index do
    selectable_column
    id_column
    column "full name", sortable: true do |n|
      n.name.full 
    end
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :middle_name
  filter :role
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  scope :recently_added
  scope :total_users
  scope :admins
  scope :registrars
  scope :department_head
  scope :dean

  form do |f|
    f.inputs "Adminstration Account" do
      f.input :first_name
      f.input :last_name
      f.input :middle_name
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      if !f.object.new_record?
        f.input :current_password
      end
      f.input :role,  :as => :select, :collection => [["Admin","admin"], ["Registrar","registrar"], ["Finance","finance"], ["Department head", "department head"],["Dean","dean"]], label: "Account Role", :include_blank => false
    end
    f.actions
  end

end
