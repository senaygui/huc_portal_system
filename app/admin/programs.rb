ActiveAdmin.register Program do

  permit_params :department_id,:program_name,:overview,:program_description,:created_by,:last_updated_by,:study_level,:admission_type,:program_duration

  index do
    selectable_column
    column :program_name
    column "Department", sortable: true do |d|
      link_to d.department.department_name, [:admin, d.department]
    end
    ## TODO: color label admission_type and study_level
    ## TODO: display number of currently admitted students in this program
    ## TODO: add number of courses
    ## TODO: add total cost of the program
    column :study_level
    column :admission_type
    column :program_duration
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :program_name
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :study_level, as: :select, :collection => ["undergraduate", "graduate"]
  filter :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"]
  filter :program_duration, as: :select, :collection => [1, 2,3,4,5,6,7]       
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  scope :undergraduate
  scope :graduate
  scope :online
  scope :regular
  scope :extention
  scope :distance
  form do |f|
    f.semantic_errors
    f.inputs "porgram information" do
      f.input :program_name
      f.input :overview,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :program_description,  :input_html => { :class => 'autogrow', :rows => 10, :cols => 20}
      f.input :department_id, as: :search_select, url: admin_departments_path,
          fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
          order_by: 'id_asc'
      f.input :study_level, as: :select, :collection => ["undergraduate", "graduate", "TPVT"]
      f.input :admission_type, as: :select, :collection => ["online", "regular", "extention", "distance"]
      f.input :program_duration, as: :select, :collection => [1, 2,3,4,5,6,7]
      if f.object.new_record?
        f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      else
        f.input :last_updated_by, as: :hidden, :input_html => { :value => current_admin_user.name.full}
      end      
    end
    f.actions
  end

  show title: :program_name do
    panel "Program information" do
      attributes_table_for program do
        row :program_name
        row :overview
        row :program_description
        row "Department", sortable: true do |d|
          link_to d.department.department_name, [:admin, d.department] 
        end
        ## TODO: add total cost of the program
        ## TODO: display number of currently admitted students in this program
        ## TODO: color label admission_type and study_level
        row :study_level
        row :admission_type
        row :program_duration
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
  end
  ## TODO: add lists of courses
  ## TODO: total number of courses on sidebar
  ## TODO: add total cost of the program on sidebar
  sidebar "carculum", :only => :show do
    # table_for catagory.products do

    #   column "Product name" do |product|
    #     link_to product.product_name, admin_product_path(product.id)
    #   end
    # end
  end
end
