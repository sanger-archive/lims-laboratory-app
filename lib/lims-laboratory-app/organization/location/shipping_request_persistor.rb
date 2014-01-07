require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/organization/location/shipping_request'

module Lims::LaboratoryApp
  module Organization
    class Location
      class ShippingRequest
        does "lims/core/persistence/persistable"
        class ShippingRequestPersistor

          def filter_attributes_on_save(attributes, *params)
            location = attributes.delete(:location)
            attributes[:location_id] = @session.id_for(location)
            attributes
          end

          def filter_attributes_on_load(attributes, *params)
            location_id = attributes[:location_id]
            attributes[:location] = @session.location[location_id]
            attributes
          end
        end
      end
    end
  end
end