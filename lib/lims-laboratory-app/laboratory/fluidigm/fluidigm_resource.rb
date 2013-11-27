#fluidigm_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/laboratory/fluidigm'
require 'lims-laboratory-app/laboratory/container/children_to_stream'
require 'lims-laboratory-app/laboratory/container/receptacle'

module Lims::LaboratoryApp
  module Laboratory
    class Fluidigm
      class FluidigmResource < Lims::Api::CoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::Container::ChildrenToStream

        def elements_name
          "fluidigm_wells"
        end
      end
    end
  end
end
