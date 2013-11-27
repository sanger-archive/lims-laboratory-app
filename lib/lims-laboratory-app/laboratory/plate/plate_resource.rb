#plate_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/laboratory/container/children_to_stream'
require 'lims-laboratory-app/laboratory/container/receptacle'

module Lims::LaboratoryApp
  module Laboratory
    class Plate
      class PlateResource < LabellableCoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::Container::ChildrenToStream

        def elements_name
          "wells"
        end

      end
    end
  end
end
