require 'lims-core/actions/action'
require 'lims-laboratory-app/organization/location/shipping_request'

module Lims::LaboratoryApp
  module Organization
    class Location
      class ShippingRequest
        class CreateShippingRequest
          include Lims::Core::Actions::Action

          attribute :name, String, :required => true
          attribute :location, Location, :required => true

          def _call_in_session(session)
            shipping_request = ShippingRequest.new( {
                :name     => name,
                :location  => location
            })
            session << shipping_request

            { :shipping_request => shipping_request, :uuid => session.uuid_for!(shipping_request) }
          end
        end

        Create = CreateShippingRequest
      end
    end
  end
end
