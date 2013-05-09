class Property::Amavis< Property

  def self.service; AMAVIS ;end

  default_scope where(:service => self.service)


  def self.binary_template(a, locals)
    a.edit :file => "#{etc_amavis}/50-user" do
      locals.each do |key, value|
        value = value == true or value == '1' ? '1' : '0'
        delete /^\$#{key}.*;.*$/
        append "$#{key} = #{value};"
      end
    end
  end

  def self.number_variable_template(a, locals)
    a.edit :file => "#{etc_amavis}/50-user" do
      locals.each do |key, value|
        delete /^\$#{key}.*;.*$/
        append "$#{key} = #{value};"
      end
    end
  end

  def self.string_variable_template(a, locals)
    a.edit :file => "#{etc_amavis}/50-user" do
      locals.each do |key, value|
        delete /^\$#{key}.*;.*$/
        append "$#{key} = '#{value}';"
      end
    end
  end


protected

  def self.etc_amavis
    '/etc/amavis/conf.d'
  end


end
