require 'spec_helper'

describe EstimatesController do
  before(:each) do
    @current_user = Factory.create(:user)
  end

  describe "GET 'new'" do
    it "assigns all estimates as @estimates" do
      estimate =  Factory(:estimate)
      get :index
      assigns(:estimates).should eq([estimate])
    end
    
    
  end

end
