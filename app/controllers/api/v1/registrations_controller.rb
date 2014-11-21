module Api
  module V1
    class RegistrationsController < Api::V1::BaseController

      skip_before_filter :require_user, :only => :create

      def create

        proc_code = Proc.new do

          @user = User.new(user_params)

          if @user.valid?
            @user.save
            @data = @user
            @alert = I18n.translate("registration.success")
          else
            @alert = I18n.translate("response.validation_error")
            @errors = @user.errors
            raise ValidationError
          end

        end
        render_json_response(proc_code)
      end

      def user_params
        params.require(:user).permit(:name, :username, :email, :biography, :password, :password_confirmation)
      end

    end
  end
end
