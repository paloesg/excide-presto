require 'test_helper'

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "should get registration" do
    get authentications_registration_url
    assert_response :success
  end

end
