module AuthenticationHelper
  def sign_in_as_a_valid_user(user = nil)
    sign_in_user = user || FactoryGirl.create(:approved_user)
    sign_in_user.reset_authentication_token! unless sign_in_user.authentication_token
    set_cookie "authentication_token=#{sign_in_user.authentication_token}"
  end
  def sign_in_credentials(user = nil, password = "Password1")
    sign_in_user = user || FactoryGirl.create(:approved_user)
    {login_handle: sign_in_user.username, password: password}
  end
  def symbolize_keys(hsh)
    hsh.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
end