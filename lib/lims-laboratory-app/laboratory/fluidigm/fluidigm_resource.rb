#fluidigm_resource.rb
require 'lims-api/resources/receptacle'
require 'lims-api/resources/container'
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/laboratory/fluidigm'

module Lims::LaboratoryApp
  module Laboratory
    class Fluidigm
      class FluidigmResource < Lims::Api::CoreResource

        include Lims::Api::Resources::Receptacle
        include Lims::Api::Resources::Container

        def elements_name
          "fluidigm_wells"
        end
      end
    end
  end
end
