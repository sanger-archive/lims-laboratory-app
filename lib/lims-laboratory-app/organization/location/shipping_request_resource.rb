require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/organization/location/shipping_request'

module Lims::LaboratoryApp
  module Organization
    class Location
      class ShippingRequest
        class ShippingRequestResource < Lims::Api::CoreResource
          def content_to_stream(s, mime_type)
            s.add_key "name"
            s.add_value object.name
            s.add_key "location"
            s.with_hash do
              location_to_stream(s, mime_type, object.location)
            end
          end

          def location_to_stream(s, mime_type, location)
            location.attributes.each do |key, value|
              s.add_key key
              s.add_value value
            end
          end
        end
      end
    end
  end
end
