class Property < ActiveRecord::Base

  self.table_name = 'server_configuration'

  attr_reader :collection, :multiple, :translate

  validates_presence_of :key, :value, :service
  validates_with PropertyValueValidator

  has_paper_trail :ignore => [:new_value], :skip => [:new_value, :template]

  def self.service; APPLICATION ;end

  def self.add(service, key, value, template)
    p = Property.find_by_key(key)||Property.new
    p.key = key; p.value = value; p.template = template
    case service
      when :postfix
        p.service = POSTFIX
      when :dovecot
        p.service = DOVECOT
      when :awstats
        p.service = AWSTATS
      when :dspam
        p.service = DSPAM
      when :nginx
        p.service = NGINX
      when :amavis
        p.service = AMAVIS
      when :spamassassin
        p.service = SPAMASSASSIN
      else
    end
    p.save
  end

  def self.all_new_values
    self.select([:key, :value, :new_value]).where 'new_value is not null'
  end

  def self.all_new_values_for_write
    properties = self.where 'new_value is not null'
    # template = "template+type", so remove '+type'
    properties.map {|p| p.template.sub!(/\+.*/, ''); p }
  end

  def self.all_to_show
    properties = self.select [:id, :key, :value, :new_value, :template]
    # template = "template+type", so remove 'template+'
    properties.map {|p| p.template.sub!(/.*\+/, ''); p }
  end

  def input_type
    t = template.to_sym
    if :yes_no ==  t
      @collection = [ 'yes', 'no' ]
      @translate = true
      return :radio_buttons

    elsif :on_off == t
      @collection = [ 'on', 'off']
      @translate = true
      return :radio_buttons

    elsif [:select_from_enum, :select_from_list].include? t
      arr = self.value.split(';')
      @collection = arr.map {|s| s.sub('+','') }
      @translate = t == :select_from_enum
      self.value = arr.select {|s| s.first == '+' }.first[1..-1]
      return :select

    elsif [:multiselect_from_enum, :multiselect_from_list].include? t
      arr = self.value.split(';')
      @collection = arr.map {|s| s.sub('+','') }
      @multiple = true
      @translate = t == :multiselect_from_enum
      self.value = arr.map {|s| s[1..-1] if s.first == '+' }.compact
      return :select

    elsif [:integer, :select].include? t
      return t

    else
      return :string
    end
  end

  def has_new_value?
    !self.new_value.nil?
  end

  def set_value(value)
    self.update_attribute :new_value, value
  end

protected

  APPLICATION   = 0

  POSTFIX       = 1
  DOVECOT       = 2
  NGINX         = 3
  DSPAM         = 4
  AMAVIS        = 5
  AWSTATS       = 6
  SPAMASSASSIN  = 7

end
