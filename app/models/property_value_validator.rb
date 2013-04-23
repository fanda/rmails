class PropertyValueValidator < ActiveModel::Validator

  def validate(record)
    return true unless record.new_value
    template, rxp = record.template.split('+')
    rxp = template unless rxp
    if validation = Validations[rxp]
      if record.new_value ~! validation
        record.errors[:base] << I18n.t('validation.format')
        return false
      end
    end
    true
  end

private

  Validations = {
      'on_off' => /\A(on)|(off)\Z/i,

      'yes_no' => /\A(yes)|(no)\Z/i,

      'mega_size' => /\A\d+[bBkKmMgG]?\Z/i,

      'mail_name' => /\A[a-z0-9](\s|[a-z0-9])*\Z/i,

      'domain' => /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}\Z/i,

      'param_string' => /\A(\w|\d|\s|\$|@|%|_|-|\.|:)*\Z/i,

      'string' => /\A[a-zA-Z0-9_-]*\Z/i,

      'number' => /\A(\+|-)?\d+\Z/i,

      'percent' => /\A\d+%\Z/i,

      'select_from_enum' => /\A(\+?\w+;?)*\Z/i
  }


end
