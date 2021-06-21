ActiveAdmin.register Program do

  permit_params :program_name,:description,:created_by,:last_updated_by

  index do
    selectable_column
    column :program_name
    column "Departments", sortable: true do |c|
      status_tag "#", class: "total_sale"
    end
    column :description
    column :created_by
    column :last_updated_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :program_name
  filter :description
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  scope :recently_added
  
  form do |f|
    f.semantic_errors
    f.inputs "porgram information" do
      f.input :program_name
      f.input :description
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
        row :description
        row "Departments", sortable: true do |c|
          status_tag "#", class: "total_sale"
        end
        row :created_by
        row :last_updated_by
        row :created_at
        row :updated_at
      end
    end
  end
  
  sidebar "Departments", :only => :show do
    # table_for catagory.products do

    #   column "Product name" do |product|
    #     link_to product.product_name, admin_product_path(product.id)
    #   end
    # end
  end
end
