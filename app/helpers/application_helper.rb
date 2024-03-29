module ApplicationHelper
  def link_to_remove_fields(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association, classes)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", classes)
  end

  def link_to_add_negotiate_fields(name, f, association, classes)
    new_object = f.object.class.reflect_on_association(association).klass.new

    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_negotiate_fields(this, '#{association}', '#{escape_javascript(fields)}')", classes)
  end

  def login_link(subdomain)
    if !subdomain.present? || subdomain == "www"
      return link_to "Login", find_subdomain_url(:subdomain => 'www')
    else
      return link_to "Login", log_in_path
    end
  end

  def vendor_status
    if current_user
      return "vendor_#{signed_in_client.is_account_master}"
    else
      return ""
    end
  end
end
