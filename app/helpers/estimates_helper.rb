module EstimatesHelper
  def who_is_negotiating(user_email)
    user = User.find_by_email(user_email)
    client = Client.find(user.client_id)
    if client == signed_in_client
      neg_client = "us"
    else
      neg_client = "them"
    end
    neg_client
  end
  
  def disable_negotiate_button(line_item)
    last_negotiate_line = line_item.negotiate_lines.find(:last)
    status = true if last_negotiate_line and who_is_negotiating(last_negotiate_line.user_negotiating) == "us"
  end
  
  def disable_form(line_item)
    disable_status = false
    if !signed_in_client.is_account_master
      disable_status = true
    elsif !line_item.negotiate_lines.empty?
      disable_status = true
    end
    disable_status
  end
  
end
