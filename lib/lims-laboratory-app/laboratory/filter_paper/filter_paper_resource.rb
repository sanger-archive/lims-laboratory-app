require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/container/receptacle'
require 'lims-laboratory-app/laboratory/location_resource_shared'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class FilterPaperResource < LabellableCoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::LocationResourceShared

        def content_to_stream(s, mime_type)
          super(s, mime_type)
          location_to_stream(s, object.attributes[:location]) if object.attributes[:location]
          s.add_key "aliquots"
          receptacle_to_stream(s, object, mime_type)
        end
      end
    end
  end
end
