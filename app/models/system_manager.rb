class SystemManager

  attr_reader :interpreter

  SERVICES = ['rmails', 'postfix', 'dovecot', 'nginx', 'dspam', 'amavisd']

  def self.change_configuration_and_restart
    sm = ServiceManager.new
    sm.write_new_values_for Property::Dovecot
    sm.write_new_values_for Property::Postfix
    sm.write_new_values_for Property::Dspam
    sm.smart_restart_all
  end

  def self.run(service, goal)
    sm = ServiceManager.new
    sm.send "#{service}_switch", goal
  end

  def restart_all
    SERVICES[1..-1].each do |s|
      @interpreter.service_manager.restart s
    end
  end

  def smart_restart_all
    @services_to_restart.each do |klass|
      @interpreter.service_manager.restart SERVICES[klass.service]
    end
    @services_to_restart = []
  end

  def initialize
    @i = @interpreter = AutomateIt.new
    @services_to_restart = []
  end

  def write_new_values_for(properties_of_service)
    # find properties to write
    new_values = properties_of_service.all_new_values_for_write
    if new_values.any?
      @services_to_restart << properties_of_service
    else
      return true
    end
    # update database in transaction
    properties_of_service.transaction do
      new_values.each do |property|
        property.value = property.new_value
        property.new_value = nil
        property.save
      end
    end
    # write properties with template
    new_values.group_by(&:template).each do |template, properties|
      locals = {}
      properties.each do |property|
        locals[property.key] = property.value
      end
      properties_of_service.send "#{template}_template", @interpreter, locals
    end
  end

  def dspam_switch(goal)
    Property::Postfix.dspam_power @interpreter, goal
    action = goal ? 'restart' : 'stop'
    @i.service_manager.send('restart', "postfix") # postfix will only restart
    @i.service_manager.send(action, "dspam")
  end


  def amavis_switch(goal)

  end

  def dkim_switch(goal)
    Property::Postfix.dkim_power @interpreter, goal
    action = goal ? 'restart' : 'stop'
    @i.service_manager.send('restart', "postfix")
    @i.service_manager.send(action, "opendkim")
  end

  def postfix_switch(goal)
    action = goal ? 'restart' : 'stop'
    @i.service_manager.send(action, "postfix")
  end

end
