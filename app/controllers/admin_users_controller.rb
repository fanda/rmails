class AdminUsersController < ApplicationController

  def index
    @admins = AdminUser.includes(:virtual_domains)
  end


  def first
    @admin = AdminUser.new
  end

  def create # JSON or HTML
    @admin = AdminUser.new(params[:admin_user])
    if @admin.save
      respond_to do |format|
        format.json { render :json => {:id => @admin.id} }
        format.html {
          flash[:success] = t('first_admin_user_success')
          #respond_with @admin, :location => domains_path
          sign_in(@admin, :bypass => true)
          redirect_to domains_path
        }
      end
    else
      respond_to do |format|
        format.json { render :json => {:errors => @admin.errors.to_json } }
        format.html {
          flash[:error] = t('first_admin_user_error')
          render :action => 'first'
        }
      end
    end
  end

  def update # JSON only
    @admin = AdminUser.find(params[:id])
    if  @admin == current_admin_user or current_admin_user.super
      if @admin.change_data params
        render :json => {:id => @admin.id}
      else
        render :json => {:errors => @admin.errors.to_json}
      end
    else
      render :json => {:errors => t('not_authorized')}
    end
  rescue
    render :json => {:errors => t('unknown_error')}
  end


  def destroy # JSON only
    if current_admin_user.super
      AdminUser.find(params[:id]).destroy
      render :json => {:id => nil}
    else
      render :status => 405
    end
  rescue
    render :status => 404
  end

end
