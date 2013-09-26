require 'spec_helper'

describe Spree::AddressesController do

  describe "GET index" do
    before(:each) do
      controller.stub(:authenticate_spree_user!).and_return(true)
      @address = mock_model(Spree::Address)
      @current_user_addresses = [@address]
      @current_user_addresses.stub(:where).and_return(@current_user_addresses)
      @current_user_addresses.stub(:includes).and_return(@current_user_addresses)
      @current_user = mock_model(Spree::User, :addresses => @current_user_addresses, :generate_spree_api_key! => false, :last_incomplete_spree_order => nil)
      controller.stub(:spree_current_user).and_return(@current_user)
      @current_user_addresses.stub(:not_deleted).and_return(@current_user_addresses)
      controller.stub(:load_resource).and_return(@address)
      controller.stub(:authorize_resource).and_return(true)
      @roles = []
      @current_user.stub(:roles).and_return(@roles)
      @address.stub(:ability)
      controller.stub(:find_resource).and_return(@address)
    end

    def send_request
      get :index, :use_route => 'spree'
    end

    it "finds current_user addresses" do
      @current_user.should_receive(:addresses)
      send_request
    end

    it "eager loads state and country" do
      @current_user_addresses.should_receive(:includes).with(:state, :country)
      send_request
    end

    it "assigns @addresses" do
      send_request
      assigns(:addresses).should eq(@current_user_addresses)
    end

    it "renders index template" do
      send_request
      response.should render_template(:index)
    end
  end

end