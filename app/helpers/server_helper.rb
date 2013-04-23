module ServerHelper

  def property_input(form, p)
    input_type = p.input_type # this must be before all other
    if p.translate
      collection = p.collection.map {|s|[t("collection.#{p.template}.#{s}"), s]}
    else
      collection = p.collection
    end
    return form.simple_fields_for(p) do |f|
      concat f.input  p.has_new_value? ? :new_value : :value,
                      :label  => t("server.key.#{p.key}"),
                      :as     => input_type,
                      :hint   => t("server.help.#{p.key}"),
                      :required => false,
                      :input_html => {
                        :multiple => p.multiple||false,
                        :name  => "property[#{p.id}]",
                        :id    => p.key
                      },
                      :wrapper_html => {
                        :id => "#{p.key}_input",
                        :class => (p.has_new_value? ? 'warning' : nil)
                      },
                      :collection => collection||[],
                      :include_blank => false
    end
  end

end
