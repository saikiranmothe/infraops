require "spec_helper"

describe "User Registration" , :type => :api do

  describe "Positive Case" do
    it "should return the user information with valid auth token after successful registration" do
      registration_information = {user: {name: "Mohandas Gandhi", username: "mohandas", email: "mohandas@gandhi.com", biography: "Father of the nation, India", password: "Password1", password_confirmation: "Password1"}}
      post "/api/v1/register", registration_information, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(true)
      actual_response[:alert].should eql("You have successfully registered.")
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

    def valid_user_information
      {user: {name: "Mohandas Gandhi", username: "mohandas", email: "mohandas@gandhi.com", biography: "Father of the nation, India", password: "Password1", password_confirmation: "Password1"}}
    end

    it "should return error for invalid name" do
      invalid_info = valid_user_information.dup
      invalid_info[:user].delete(:name)
      post "/api/v1/register", invalid_info, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data].should be_present

      actual_response[:data]["errors"]["name"].should eql("ValidationError")
      actual_response[:data]["errors"]["description"].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data]["errors"]["details"].should eql({"name"=>["can't be blank", "is too short (minimum is 2 characters)"]})
    end

    it "should return error for invalid email" do
      invalid_info = valid_user_information.dup
      invalid_info[:user].delete(:email)
      post "/api/v1/register", invalid_info, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data].should be_present

      actual_response[:data]["errors"]["name"].should eql("ValidationError")
      actual_response[:data]["errors"]["description"].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data]["errors"]["details"].should eql({"email"=>["can't be blank"]})
    end

    it "should return error for invalid username" do
      invalid_info = valid_user_information.dup
      invalid_info[:user].delete(:username)
      post "/api/v1/register", invalid_info, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data].should be_present

      actual_response[:data]["errors"]["name"].should eql("ValidationError")
      actual_response[:data]["errors"]["description"].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data]["errors"]["details"].should eql({"username"=>["can't be blank", "is too short (minimum is 6 characters)"]})
    end

    it "should return error for invalid password" do
      invalid_info = valid_user_information.dup
      invalid_info[:user].delete(:password)
      post "/api/v1/register", invalid_info, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data].should be_present

      actual_response[:data]["errors"]["name"].should eql("ValidationError")
      actual_response[:data]["errors"]["description"].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data]["errors"]["details"].should eql({"password"=>["can't be blank", "is invalid"]})
    end

    it "should return error for invalid password confirmation" do
      invalid_info = valid_user_information.dup
      invalid_info[:user].delete(:password_confirmation)
      post "/api/v1/register", invalid_info, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data].should be_present

      actual_response[:data]["errors"]["name"].should eql("ValidationError")
      actual_response[:data]["errors"]["description"].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data]["errors"]["details"].should eql({"password_confirmation"=>["can't be blank"]})
    end

    it "should return error for invalid password confirmation" do
      invalid_info = valid_user_information.dup
      invalid_info[:user][:password_confirmation] = "some password"
      post "/api/v1/register", invalid_info, :format =>:json
      last_response.status.should eql(200)
      actual_response = symbolize_keys(JSON.parse(last_response.body))
      actual_response.keys.should eql([:success, :alert, :data])
      actual_response[:success].should eql(false)
      actual_response[:alert].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data].should be_present

      actual_response[:data]["errors"]["name"].should eql("ValidationError")
      actual_response[:data]["errors"]["description"].should eql("Sorry, there are errors with the information you provided. Please review the data you have entered.")
      actual_response[:data]["errors"]["details"].should eql({"password_confirmation"=>["doesn't match Password"]})
    end
  end

end