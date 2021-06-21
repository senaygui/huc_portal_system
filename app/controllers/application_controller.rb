class ApplicationController < ActionController::Base
  def access_denied(exception)
    flash[:error] = exception.message
    
    redirect_to admin_root_path 
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end

  def current_ability
    if current_admin_user.kind_of?(AdminUser)
      @current_ability ||= Ability.new(current_admin_user)
    else
      @current_ability ||= UserAbility.new(current_user)
    end
  end
end
