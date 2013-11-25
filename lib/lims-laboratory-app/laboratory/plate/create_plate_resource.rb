require 'lims-api/core_action_resource'

require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/laboratory/container/create_container_resource'

module Lims::LaboratoryApp
  module Laboratory
    class Plate
      class CreatePlateResource < Lims::Api::CoreActionResource
        include Lims::LaboratoryApp::Laboratory::Container::CreateContainerResource

        def self.element_attr
          'wells_description'
        end

        def self.element_attr_sym
          :wells_description
        end
      end
    end
  end
end
