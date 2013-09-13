require 'lims-laboratory-app/laboratory/container'
require 'lims-laboratory-app/laboratory/aliquot/aliquot_persistor'
module Lims::LaboratoryApp
  module Laboratory
    module Container::ContainerElementPersistor

      def save(element, container_id, position)
        #todo bulk save if needed
        element.each do |aliquot|
          save_as_aggregation(container_id, aliquot, position)
        end
      end

    end
  end
end
