class ApiError < RuntimeError

  attr_accessor :alert, :heading, :data, :errors, :redirect_on_failure, :redirect_on_success

  def initialize(options={})
    self.alert = options[:alert]
    self.heading = options[:heading]
    self.data = options[:data]
    self.errors = options[:errors]
    self.redirect_on_failure = options[:redirect_on_failure]
    self.redirect_on_success = options[:redirect_on_success]
  end

end

class InvalidLoginError < ApiError
end

class ValidationError < ApiError
end

class FailedToCreateError < ApiError
end

class FailedToUpdateError < ApiError
end

class FailedToDeleteError < ApiError
end

class AuthenticationError < ApiError
end