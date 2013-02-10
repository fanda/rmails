class Property::Postfix < Property

  def self.service; POSTFIX ;end

  default_scope where(:service => self.service)

end
