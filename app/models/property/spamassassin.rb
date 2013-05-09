class Property::Spamassassin< Property

  def self.service; SPAMASSASSIN ;end

  default_scope where(:service => self.service)


  def self.preference_template(a, locals)
    a.edit :file => "#{etc_sa}/local.cf" do
      locals.each do |key, value|
        delete /^#{key}.*$/
        append "#{key} #{value}"
      end
    end
  end


protected

  def self.etc_sa
    '/etc/spamassassin'
  end


end
