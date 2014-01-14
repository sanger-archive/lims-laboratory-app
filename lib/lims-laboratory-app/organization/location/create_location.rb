require 'lims-core/actions/action'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Organization
    class Location

      class CreateLocation
        include Lims::Core::Actions::Action

        attribute :name, String, :required => true
        attribute :address, String, :required => true
        attribute :internal, TrueClass, :required => false

        def _call_in_session(session)
          location = Location.new( {
              :name     => name,
              :address  => address,
              :internal => internal
          })
          session << location

          { :location => location, :uuid => session.uuid_for!(location) }
        end
      end

      Create = CreateLocation

    end
  end
end
