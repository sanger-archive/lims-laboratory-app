require 'lims-api/core_action_resource'
require 'lims-api/resources/create_container'

require 'lims-laboratory-app/laboratory/fluidigm'

module Lims::LaboratoryApp
  module Laboratory
    class Fluidigm
      class CreateFluidigmResource < Lims::Api::CoreActionResource
        include Lims::Api::Resources::CreateContainer

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
