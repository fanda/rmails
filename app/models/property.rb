class Property < ActiveRecord::Base

  self.table_name = 'server_configuration'

  attr_accessible :key, :value, :service

  def self.get(key)
    if p = find_by_key_and_service(key, self.service)
      return p.value
    end
    nil
  end

  def self.set(key, value)
    if p = find_by_key_and_service(key, self.service)
      p.update_attribute :value, value
    else
      create({:key => key, :value => value, :service => self.service})
    end
  end

  def self.service; ABSTRACT ;end

protected

  ABSTRACT  = 0

  POSTFIX   = 1
  DOVECOT   = 2
  NGINX     = 3
  AWSTATS   = 4

end
