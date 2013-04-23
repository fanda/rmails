module AdminUsersHelper

  def admin_ejs_object
    AdminUser.new({
      #:super => "<%= item.super %>".html_safe,
      :email    => "<%= item.email %>".html_safe,
      :name => "<%= item.name %>".html_safe
    })
  end

end
