require 'spec_helper'

describe User do
  describe "Factory" do
    it "should create valid factories" do
      user = FactoryGirl.create(:user)
      user.should be_persisted

      user = FactoryGirl.create(:pending_user)
      user.should be_persisted

      user = FactoryGirl.create(:approved_user)
      user.should be_persisted

      user = FactoryGirl.create(:blocked_user)
      user.should be_persisted
    end
  end

  describe "Validations" do

    let(:unsaved_user) { FactoryGirl.build(:user) }
    let(:saved_user) { FactoryGirl.create(:user) }

    describe "email" do

      it "should accept valid email addresses on create" do
        valid_emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
        valid_emails.each do |valid_email|
          unsaved_user.email = valid_email
          unsaved_user.valid?
          unsaved_user.should be_valid
        end
      end

      it "should accept valid email addresses on update" do
        valid_emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
        valid_emails.each do |valid_email|
          saved_user.email = valid_email
          saved_user.valid?
          saved_user.should be_valid
        end
      end

      it "should reject invalid email addresses on create" do
        invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.]
        invalid_emails.each do |invalid_email|
          unsaved_user.email = invalid_email
          unsaved_user.valid?
          unsaved_user.should be_invalid
          unsaved_user.should have(1).error_on(:email)
        end
      end

      it "should reject invalid email addresses on update" do
        invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.]
        invalid_emails.each do |invalid_email|
          saved_user.email = invalid_email
          saved_user.valid?
          saved_user.should be_invalid
          saved_user.should have(1).error_on(:email)
        end
      end

      it "should reject email addresses identical up to case on create" do
        existing_user = FactoryGirl.create(:user)
        unsaved_user.email = existing_user.email.upcase
        unsaved_user.valid?
        unsaved_user.should be_invalid
        unsaved_user.should have(1).error_on(:email)
      end

      it "should reject email addresses identical up to case on update" do
        existing_user = FactoryGirl.create(:user)
        saved_user.email = existing_user.email.upcase
        saved_user.valid?
        saved_user.should be_invalid
        saved_user.should have(1).error_on(:email)
      end
    end

    describe "username" do

      # Refer initializers/config_center.rb
      # Minimum length is 4 by default and maximum length is 255 by default
      # Only characters (both upper and lowercase), numbers, dot(.), underscore (_)
      # No spaces, hyphen or any other special characters are allowed

      it "should not allow to save without a username on create" do
        unsaved_user.username = ""
        unsaved_user.valid?
        unsaved_user.should be_invalid

        unsaved_user.username = nil
        unsaved_user.valid?
        unsaved_user.should be_invalid
      end

      it "should not allow to save without a username on update" do
        saved_user.username = ""
        saved_user.valid?
        saved_user.should be_invalid

        saved_user.username = nil
        saved_user.valid?
        saved_user.should be_invalid
      end

      it "should accept valid usernames on create" do
        valid_usernames = %w[1234567 abcdefg ABCDEFG ABCdef123 kp_varma alex12 r_joshi]
        valid_usernames.each do |valid_username|
          unsaved_user.username = valid_username
          unsaved_user.valid?
          unsaved_user.should be_valid
        end
      end

      it "should accept valid usernames on update" do
        valid_usernames = %w[1234567 abcdefg ABCDEFG ABCdef123 kp_varma alex12 r_joshi]
        valid_usernames.each do |valid_username|
          saved_user.username = valid_username
          saved_user.valid?
          saved_user.should be_valid
        end
      end

      it "should reject invalid usernames on create" do
        invalid_usernames = %w[123 asd joshi(r) abcdef#1233@ abcd123@ JP0!12@34A]
        invalid_usernames.each do |invalid_username|
          unsaved_user.username = invalid_username
          unsaved_user.valid?
          unsaved_user.should be_invalid
          unsaved_user.should have(1).error_on(:username)
        end

        # Checking Space
        unsaved_user.username = "raghu joshi"
        unsaved_user.valid?
        unsaved_user.should be_invalid
        unsaved_user.should have(1).error_on(:username)

        # Checking 256+ characters
        unsaved_user.username = "r"*257
        unsaved_user.valid?
        unsaved_user.should be_invalid
        unsaved_user.should have(1).error_on(:username)
      end

      it "should reject invalid usernames on update" do
        invalid_usernames = %w[123 asd joshi(r) abcdef#1233@ abcd123@ JP0!12@34A]
        invalid_usernames.each do |invalid_username|
          saved_user.username = invalid_username
          saved_user.valid?
          saved_user.should be_invalid
          saved_user.should have(1).error_on(:username)
        end

        # Checking Space
        saved_user.username = "raghu joshi"
        saved_user.valid?
        saved_user.should be_invalid
        saved_user.should have(1).error_on(:username)

        # Checking 256+ characters
        saved_user.username = "r."*256
        saved_user.valid?
        saved_user.should be_invalid
        saved_user.should have(2).error_on(:username)
      end

      it "should reject duplicate usernames on create" do
        existing_user = FactoryGirl.create(:user)
        unsaved_user.username = existing_user.username
        unsaved_user.valid?
        unsaved_user.should be_invalid
        unsaved_user.should have(1).error_on(:username)
      end

      it "should reject duplicate usernames on update" do
        existing_user = FactoryGirl.create(:user)
        saved_user.username = existing_user.username
        saved_user.valid?
        saved_user.should be_invalid
        saved_user.should have(1).error_on(:username)
      end

      it "should reject usernames identical up to case on create" do
        existing_user = FactoryGirl.create(:user)
        unsaved_user.username = existing_user.username.upcase
        unsaved_user.valid?
        unsaved_user.should be_invalid
        unsaved_user.should have(1).error_on(:username)
      end

      it "should reject usernames identical up to case on update" do
        existing_user = FactoryGirl.create(:user)
        saved_user.username = existing_user.username.upcase
        saved_user.valid?
        saved_user.should be_invalid
        saved_user.should have(1).error_on(:username)
      end
    end

    describe "name" do

      ## 3 - 12 characters -[ a-z, A-Z, <space> and . ]
      it "should accept valid names" do
        names = ["Krishnaprasad Varma" "Raghu Joshi" "KPVarma" "K P Varma"]
        names.each do |name|
          saved_user.name = name
          saved_user.valid?
          saved_user.should be_valid
        end
      end

      it "should accept invalid names" do
        names = ["Krishnaprasad123" "K-P Varma" "KPVarma$" "kp varma 12"]
        names.each do |name|
          saved_user.name = name
          saved_user.valid?
          saved_user.should be_invalid
          saved_user.should have(1).error_on(:name)
        end
      end
    end

    describe "status" do

      it "should be default to pending on create if no status us assigned by default" do
        unsaved_user.save!
        unsaved_user.valid?
        unsaved_user.should be_pending
      end

      it "should accept valid status on create" do
        statuses = ConfigCenter::User::STATUS_LIST.keys
        statuses.each do |status|
          unsaved_user.status = status
          unsaved_user.valid?
          unsaved_user.should be_valid
        end
      end

      it "should accept valid status on update" do
        statuses = ConfigCenter::User::STATUS_LIST.keys
        statuses.each do |status|
          saved_user.status = status
          saved_user.valid?
          saved_user.should be_valid
        end
      end

      it "should reject invalid status" do
        statuses = ["pending11","sdfdsfdsf", "123456"]
        statuses.each do |status|
          unsaved_user.status = status
          unsaved_user.valid?
          unsaved_user.should be_invalid
          unsaved_user.should have(2).error_on(:status)
        end
      end
    end
  end

  describe "Other Methods" do
    it "should find the user if email or username matches" do
      user = FactoryGirl.create(:approved_user, name: "Ram", email: "ram@domain.com", username: "ramuser1")
      User.find_by_email_or_username("ram@domain.com").should == user
      User.find_by_email_or_username("ramuser1").should == user
      User.find_by_email_or_username("Ram").should be_nil
    end
  end


end

