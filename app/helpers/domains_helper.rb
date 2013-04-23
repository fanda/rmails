module DomainsHelper

  def domain_ejs_object
    VirtualDomain.new({
      :name => "<%= item.name %>".html_safe
    })
  end

  def alias_ejs_object
    VirtualAlias.new({
      :source       => "<%= item.source %>".html_safe,
      :destination  => "<%= item.destination %>".html_safe
    })
  end

  def user_ejs_object
    VirtualUser.new({
      :email    => "<%= item.email %>".html_safe,
      :name => "<%= item.name %>".html_safe
    })
  end



end
