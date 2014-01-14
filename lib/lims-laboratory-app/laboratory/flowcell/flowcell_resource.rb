#flowcell_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/flowcell'
require 'lims-laboratory-app/laboratory/container'
require 'lims-laboratory-app/laboratory/container/receptacle'
require 'lims-laboratory-app/laboratory/location_resource_shared'

module Lims::LaboratoryApp
  module Laboratory
    class Flowcell
      class FlowcellResource < LabellableCoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::LocationResourceShared

        def content_to_stream(s, mime_type)
          s.add_key "number_of_lanes"
          s.add_value object.number_of_lanes 
          s.add_key "lanes"
          lanes_to_stream(s, mime_type)
          location_to_stream(s, object.attributes[:location]) if object.attributes[:location]
        end

        def lanes_to_stream(s, mime_type)
          s.start_hash
          object.each_with_index do |lane, id|
            s.add_key(id+1).to_s
            receptacle_to_stream(s, lane, mime_type)
          end
          s.end_hash
        end

      end
    end
  end
end
