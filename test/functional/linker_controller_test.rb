require 'test_helper'

class LinkerControllerTest < ActionController::TestCase
  test "should get forward" do
    get :forward
    assert_response :success
  end

end
