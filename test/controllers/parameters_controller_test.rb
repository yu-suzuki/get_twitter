require 'test_helper'

class ParametersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parameter = parameters(:one)
  end

  test "should get index" do
    get parameters_url
    assert_response :success
  end

  test "should get new" do
    get new_parameter_url
    assert_response :success
  end

  test "should create parameter" do
    assert_difference('Parameter.count') do
      post parameters_url, params: { parameter: { access_token: @parameter.access_token, access_token_secret: @parameter.access_token_secret, consumer_key: @parameter.consumer_key, consumer_secret: @parameter.consumer_secret, lang: @parameter.lang } }
    end

    assert_redirected_to parameter_url(Parameter.last)
  end

  test "should show parameter" do
    get parameter_url(@parameter)
    assert_response :success
  end

  test "should get edit" do
    get edit_parameter_url(@parameter)
    assert_response :success
  end

  test "should update parameter" do
    patch parameter_url(@parameter), params: { parameter: { access_token: @parameter.access_token, access_token_secret: @parameter.access_token_secret, consumer_key: @parameter.consumer_key, consumer_secret: @parameter.consumer_secret, lang: @parameter.lang } }
    assert_redirected_to parameter_url(@parameter)
  end

  test "should destroy parameter" do
    assert_difference('Parameter.count', -1) do
      delete parameter_url(@parameter)
    end

    assert_redirected_to parameters_url
  end
end
