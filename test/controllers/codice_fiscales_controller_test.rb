require "test_helper"

class CodiceFiscalesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get codice_fiscales_index_url
    assert_response :success
  end

  test "should get create" do
    get codice_fiscales_create_url
    assert_response :success
  end
end
