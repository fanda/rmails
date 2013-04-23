class AliasesController < ApplicationController

  before_filter :find_alias, :only => [:update]

  def update
    if @alias.update_attributes(params[:virtual_alias])
      render :json => {:id => @alias.id}
    else
      render :json => {:errors => @alias.errors.to_json}
    end
  rescue
    render :json => {:errors => t('unknown_error')}
  end

  def create
    @domain = current_admin_user.domain(params[:domain_id])
    @alias = @domain.virtual_aliases.build(params[:virtual_alias])
    if @alias.save
      render :json => {:id => @alias.id}
    else
      render :json => {:errors => @alias.errors.to_json}
    end
  rescue
    render :json => {:errors => t('unknown_error')}
  end


protected

  def find_alias
    @domain = current_admin_user.domain(params[:domain_id])
    @alias = @domain.virtual_aliases.where(:id => params[:id]).first
  end

end
