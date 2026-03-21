require "test_helper"

class MypageControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get mypage_show_url
    assert_response :success
  end

  test "should get edit_name" do
    get mypage_edit_name_url
    assert_response :success
  end

  test "should get edit_email" do
    get mypage_edit_email_url
    assert_response :success
  end
end
