require 'rails_helper'

module PostHelper
  def http_login
    user = 'kishore'
    pw = 'kishore'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end  
end
