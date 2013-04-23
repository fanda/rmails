class Property::Dspam< Property

  def self.service; DSPAM ;end

  default_scope where(:service => self.service)


  def self.on_off_pref_template(a, locals)
    a.edit :file => "#{etc_dspam}/dspam.conf" do
      locals.each do |key, value|
        value = value == true or value == 'on' ? 'on' : 'off'
        delete /^Preference\s+"#{key}/
        append "Preference\t\t\"#{key}=#{value}\""
      end
    end
  end

  def self.preference_template(a, locals)
    a.edit :file => "#{etc_dspam}/dspam.conf" do
      locals.each do |key, value|
        delete /^Preference\s+"#{key}/
        append "Preference\t\t\"#{key}=#{value}\""
      end
    end
  end

  def self.enum_template(a, locals)
    a.edit :file => "#{etc_dspam}/dspam.conf" do
      locals.each do |key, value|
        value = value.split(';').select {|s| sfirst=='+' }. first[1..-1]
        delete /^Preference\s+"#{key}/
        append "Preference\t\t\"#{key}=#{value}\""
      end
    end
  end


protected

  def self.etc_dspam
    '/etc/dspam'
  end


end
