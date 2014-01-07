require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/organization/location/shipping_request'
require 'lims-laboratory-app/organization/location/create_shipping_request'

module Lims::LaboratoryApp
  module Organization
    class Location
      class ShippingRequest
        class CreateShippingRequest
          class CreateShippingRequestResource < Lims::Api::CoreActionResource
            def filtered_attributes
              super.mash do |k,v|
                case k
                when :location
                  [:location_uuid,  @context.uuid_for(v)]
                else
                  [k,v]
                end
              end
            end

          end
        end
      end
    end
  end
end
