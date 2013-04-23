class Property::Awstats < Property

  def self.service; AWSTATS ;end

  default_scope where(:service => self.service)


protected

  def self.etc_awstats
    '/etc/awstats'
  end


end
