require 'common'
require 'lims-core/resource'

module Lims::LaboratoryApp
  module Organization
    # This class is an association class between a location and a labware
    # @param [String] name contains the labware's UUID
    # @param [Location] location contains the location data of the labware
    class Location
      class ShippingRequest
        include Lims::Core::Resource
        attribute :name, String, :required => true
        attribute :location, Location, :required => true
      end
    end
  end
end
