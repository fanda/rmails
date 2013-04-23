class UsersController < ApplicationController

  before_filter :find_user, :only => [:update]

  def update
    if @user.change_data params[:virtual_user]
      render :json => {:id => @user.id}
    else
      render :json => {:errors => @user.errors.to_json}
    end
  rescue
    render :json => {:errors => t('unknown_error')}
  end

  def create
    @domain = current_admin_user.domain(params[:domain_id])
    @user = @domain.virtual_users.build(params[:virtual_user])
    if @user.save
      render :json => {:id => @user.id}
    else
      render :json => {:errors => @user.errors.to_json}
    end
  rescue
    render :json => {:errors => t('unknown_error')}
  end


protected

  def find_user
    @domain = current_admin_user.domain(params[:domain_id])
    @user = @domain.virtual_users.where(:id => params[:id]).first
  end

end
