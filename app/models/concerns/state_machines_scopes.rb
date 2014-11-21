module StateMachinesScopes
  extend ActiveSupport::Concern

  included do

    # Will generate a bunch of instance methods (scopes) which can be used for filtering by status
    # == Examples
    #   >>> User.approveds
    #   >>> User.pendings
    #   => ActiveRecord::Relation Object
    self.state_machines.each do |name, machine|
      machine.states.map(&:name).each do |my_status|
        metaclass = class << self; self ; end
        metaclass.instance_eval do
          define_method(my_status.to_s.pluralize) do
            where( status: my_status )
          end
        end
      end
    end
  end

end