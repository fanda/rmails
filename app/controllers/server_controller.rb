class ServerController < ApplicationController

  def index
    properties = Property.all_to_show
    @properties_JSON = properties.to_json
    @properties = properties.index_by(&:key)
    @properties_with_new_value = Property.all_new_values
  end

  def property
    property = Property.find params[:id]
    if property.set_value(params[:value])
      render :json => {:result => 'success'}
    else
      render :json => {:errors => property.errors.to_json}
    end
  rescue
    render :json => {:errors => t('unknown_error')}
  end

  def update
    SystemManager.change_configuration_and_restart
    render :json => {:result => 'success'}
  rescue
    render :json => {:errors => t('unknown_error')}
  end

end
