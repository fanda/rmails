class Property::Dovecot < Property

  def self.service; DOVECOT ;end

  default_scope where(:service => self.service)

  def self.etc_dovecot
    '/etc/dovecot'
  end

  def self.value_template(a, locals)
    a.edit :file => "#{etc_dovecot}/dovecot.conf", :backup => false do
      locals.each do |key, value|
        replace /#{key}\s*=\s*.*/, "#{key} = #{value}"
      end
    end
  end

  def self.yes_no_template(a, values)
    a.edit  :file => "#{etc_dovecot}/dovecot.conf", :backup => false do
      values.each do |key, value|
        replace /^#{key}\s*=\s*.*$/, "#{key} = #{value}"
      end
    end
  end

  def self.commented_value_template(a, values)
    a.edit :file => "#{etc_dovecot}/dovecot.conf", :backup => false do
      values.each do |key, value|
        param_name = key.split('__').last
        rxp = /(\s*#\s#{key}\s+!!.*!!\s*$\s*#{param_name}\s*=\s*)(\d+)/
        manipulate do |text|
          text =~ rxp
          text.gsub rxp, "#{$1}#{value}"
        end
      end
    end
  end

  def self.storage_template(a, values)
    a.edit :file => "#{etc_dovecot}/dovecot.conf", :backup => false do
      values.each do |key, value|
        value += '%' if value =~ /%$/
        manipulate do |text|
          case key.to_sym
            when :storage_size
              text =~ rxp = /(\*:storage\s*=\s*).*$/
            when :storage_trash
              text =~ rxp = /(Trash:storage\s*=\s*).*$/
            when :storage_spam
              text =~ rxp = /(Spam:storage\s*=\s*).*$/
            else
          end
          text.gsub rxp, "#{$1}#{value}"
        end
      end
    end
  end


end
