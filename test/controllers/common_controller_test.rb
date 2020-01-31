require 'test_helper'

class CommonControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get common_index_url
    assert_response :success
  end

end
