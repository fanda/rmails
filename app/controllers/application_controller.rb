class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :any_admin_user_exists?, :authenticate_admin_user!,
     :unless => :first_admin_user_action?

  def any_admin_user_exists?
    return if current_admin_user
    if AdminUser.first.nil?
      redirect_to :action => 'first', :controller => 'admin_users'
    end
  end

  def first_admin_user_action?
    params[:controller] == 'admin_users' and (
      params[:action] == 'first' or params[:action] == 'create'
    )
  end

end
