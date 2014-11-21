require "spec_helper"

describe "User authentication" , :type => :api do

  let!(:approved_user) { FactoryGirl.create(:approved_user, name: "Mohandas Gandhi", username: "mohandas", email: "mohandas@gandhi.com", biography: "Father of the nation, India") }

  describe "Positive Case" do
    it "should return the user information with valid auth token" do
      post "/api/v1/sign_in", sign_in_credentials(approved_user), :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(true)
      actual_response[:alert].should eql("You have successfully signed in.")
      actual_response[:data]["name"].should eql("Mohandas Gandhi")
      actual_response[:data]["username"].should eql("mohandas")
      actual_response[:data]["email"].should eql("mohandas@gandhi.com")
      actual_response[:data]["biography"].should eql("Father of the nation, India")
      actual_response[:data]["auth_token"].should be_present
      actual_response[:data]["password"].should be_nil
      actual_response[:data]["password_digest"].should be_nil
    end
  end

  describe "Negative Case" do
    it "should return error for invalid credentials" do
      post "/api/v1/sign_in", {}, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Invalid username/email or password.")

      actual_response[:data]["errors"].should be_present
      actual_response[:data]["errors"]["name"].should eql("InvalidLoginError")
      actual_response[:data]["errors"]["description"].should eql("Invalid username/email or password.")
    end

    it "should return error for invalid password" do
      post "/api/v1/sign_in", {login_handle: approved_user.username}, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Invalid username/email or password.")

      actual_response[:data]["errors"].should be_present
      actual_response[:data]["errors"]["name"].should eql("InvalidLoginError")
      actual_response[:data]["errors"]["description"].should eql("Invalid username/email or password.")
    end
  end

end