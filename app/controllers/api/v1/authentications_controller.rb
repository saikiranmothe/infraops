module Api
  module V1
    class AuthenticationsController < Api::V1::BaseController

      skip_before_filter :require_user, :only => :create

      def create

        proc_code = Proc.new do

          # Fetching the user data (email / username is case insensitive.)
          @user = User.find_by_email_or_username(params['login_handle'])

          # If the user exists with the given username / password
          if @user
            # Check if the user is not approved (pending, locked or blocked)
            # Will allow to login only if status is approved
            if @user.status != ConfigCenter::User::APPROVED
              @alert = I18n.translate("authentication.user_is_#{@user.status.downcase}")
              raise InvalidLoginError
            # Check if the password matches
            # Invalid Login: Password / Email doesn't match
            elsif @user.authenticate(params['password']) == false
              @alert = I18n.translate("response.invalid_login_error")
              raise InvalidLoginError
            end
          # If the user with provided email doesn't exist
          else
            @alert = I18n.translate("response.invalid_login_error")
            raise InvalidLoginError
          end

          # If successfully authenticated.
          @alert = I18n.translate("authentication.logged_in_successfully")
          @data = @user

        end
        render_json_response(proc_code)
      end

      def destroy
        proc_code = Proc.new do

          raise AuthenticationError unless @current_user

          # Reseting the auth token for user when he logs out.
          @current_user.update_attribute :auth_token, SecureRandom.hex

          # If successfully authenticated.
          @alert = I18n.translate("authentication.logged_out_successfully")

        end

        render_json_response(proc_code)

      end

    end
  end
end
