require 'test_helper'

class UitgelichtsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:uitgelichts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_uitgelicht
    assert_difference('Uitgelicht.count') do
      post :create, :uitgelicht => { }
    end

    assert_redirected_to uitgelicht_path(assigns(:uitgelicht))
  end

  def test_should_show_uitgelicht
    get :show, :id => uitgelichts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => uitgelichts(:one).id
    assert_response :success
  end

  def test_should_update_uitgelicht
    put :update, :id => uitgelichts(:one).id, :uitgelicht => { }
    assert_redirected_to uitgelicht_path(assigns(:uitgelicht))
  end

  def test_should_destroy_uitgelicht
    assert_difference('Uitgelicht.count', -1) do
      delete :destroy, :id => uitgelichts(:one).id
    end

    assert_redirected_to uitgelichts_path
  end
end
