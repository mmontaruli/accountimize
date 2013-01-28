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
    elsif line_item.is_accepted
      disable_status = true
    end
    disable_status
  end

  def can_accept(negotiate_line)
    line_item = LineItem.find(negotiate_line.line_item_id)
    last_negotiate_line = line_item.negotiate_lines.find(:last)
    negotiate_line == last_negotiate_line and who_is_negotiating(negotiate_line.user_negotiating) == "them"
  end

  def can_approve_estimate(estimate)
    status = true
    estimate.line_items.each do |line_item|
      if !line_item.negotiate_lines.empty?
        if !line_item.is_accepted
          status = false
          return status
        end
      end
    end
    status
  end

  def hide_status(f)
    if !signed_in_client.is_account_master && !f.object.already_reviewed
      "hidden"
    else
      nil
    end
  end

end
