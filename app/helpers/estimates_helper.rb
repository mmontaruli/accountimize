module EstimatesHelper
  def who_is_negotiating(user_email)
    user = User.find_by_email(user_email)
    client = Client.find(user.client_id)
    if client == signed_in_client
      neg_client = "negotiator"
    else
      neg_client = "negotiatee"
    end
    neg_client
  end
  
end
