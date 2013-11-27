require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/tube_rack'
require 'lims-laboratory-app/laboratory/container/children_to_stream'
require 'lims-laboratory-app/laboratory/container/receptacle'

module Lims::LaboratoryApp
  module Laboratory
    class TubeRack
      class TubeRackResource < LabellableCoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::Container::ChildrenToStream

        def elements_name
          :tubes
        end

        def children_to_stream(s, mime_type)
          s.add_key :tubes
          tubes_to_stream(s, mime_type)
        end

        def tubes_to_stream(s, mime_type)
          tubes = {}
          object.each_with_index { |tube, location| tubes[location] = tube }
          hash_to_stream(s, tubes, mime_type)
        end

      end
    end
  end
end
