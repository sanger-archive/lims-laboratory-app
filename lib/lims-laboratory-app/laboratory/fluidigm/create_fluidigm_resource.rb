require 'lims-api/core_action_resource'

require 'lims-laboratory-app/laboratory/fluidigm'
require 'lims-laboratory-app/laboratory/container/create_container_resource'

module Lims::LaboratoryApp
  module Laboratory
    class Fluidigm
      class CreateFluidigmResource < Lims::Api::CoreActionResource
        include Lims::LaboratoryApp::Laboratory::Container::CreateContainerResource

        def self.element_attr
          'fluidigm_wells_description'
        end

        def element_attr_sym
          :fluidigm_wells_description
        end
      end
    end
  end
end
