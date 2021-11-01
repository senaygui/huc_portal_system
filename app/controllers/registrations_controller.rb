class RegistrationsController < Devise::RegistrationsController
	
	private

	# def after_sign_up_path_for(resource)
	# 	# if user_signed_in?
	# 	# 	payment_path
	# 	# end
	# end

	protected

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params["password"]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end
end
