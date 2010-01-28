require 'test_helper'

class ChartsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:charts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_chart
    assert_difference('Chart.count') do
      post :create, :chart => { }
    end

    assert_redirected_to chart_path(assigns(:chart))
  end

  def test_should_show_chart
    get :show, :id => charts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => charts(:one).id
    assert_response :success
  end

  def test_should_update_chart
    put :update, :id => charts(:one).id, :chart => { }
    assert_redirected_to chart_path(assigns(:chart))
  end

  def test_should_destroy_chart
    assert_difference('Chart.count', -1) do
      delete :destroy, :id => charts(:one).id
    end

    assert_redirected_to charts_path
  end
end
