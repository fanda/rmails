class DomainsController < ApplicationController

  def index
    @domains = current_admin_user.domains
    respond_to do |format|
      format.html # index.html.haml
      format.json { render :json => @domains }
    end
  end

  def show
    @domain = current_admin_user.domain(params[:id])
    respond_to do |format|
      format.html # show.html.haml
      format.json { render :json => @domain }
    end
  rescue
    render :status => 404
  end

  def create # JSON only
    @domain = current_admin_user.build_domain(params[:virtual_domain])
    if @domain.save
      render :json => {:id => @domain.id}
    else
      render :json => {:errors => @domain.errors}
    end
  end

  def update # JSON only
    @domain = current_admin_user.domain(params[:id])
    if @domain.update_attributes params[:virtual_domain]
      render :json => {:id => @domain.id}
    else
      render :json => {:errors => @domain.errors}
    end
  rescue
    render :status => 405
  end

  def destroy # JSON only
    current_admin_user.domain(params[:id]).destroy
    render :json => {:id => nil}
  rescue
    render :status => 405
  end

end
