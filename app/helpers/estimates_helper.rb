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
  
  # To disable negotiate button
  # This helper method would be invoked from line_item_fields partial
  # pass line_item into method
  # get all negotiate_lines that belong to line_item
  # get last negotiate_line (most recent? highest id?)
  # get user_negotiating email "users_email"
  # run who_is_negotiating method: who_is_negotiating(users_email)
  # if who_is_negotiating(users_email) returns "us", status = true
  # if who_is_negotiating(users_email) returns "them", status = false
  # (return) status
  
  def disable_negotiate_button(line_item)
    last_negotiate_line = line_item.negotiate_lines.find(:last)
    if last_negotiate_line
      if who_is_negotiating(last_negotiate_line.user_negotiating) == "us"
        status = true
      else
        status = false
      end
    else
      status = false
    end
    status
  end
  
end
