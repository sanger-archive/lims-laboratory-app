require 'lims-core/actions/action'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Organization
    class Location
      class UpdateLocation
        include Lims::Core::Actions::Action
        
        LabwareNotFoundError = Class.new(Lims::Core::Actions::Action::InvalidParameters)

        attribute :location, Organization::Location, :required => true, :writer => :private
        attribute :name, String, :required => false, :writer => :private
        attribute :address, String, :required => false, :writer => :private
        attribute :internal, TrueClass, :required => false, :writer => :private
        attribute :labware_uuids, Array, :default => [], :required => false, :writer => :private

        def _call_in_session(session)
          location.name = name if name
          location.address = address if address
          location.internal = internal unless internal == nil

          labware_uuids.each do |uuid|
            labware = session[uuid]
            raise LabwareNotFoundError,
              {"labware_uuids" => "The labware with the following UUID is not exist: #{uuid}"} unless labware
            labware.location = location
          end

          {:location => location}
        end
      end

      Update = UpdateLocation
    end
  end
end
