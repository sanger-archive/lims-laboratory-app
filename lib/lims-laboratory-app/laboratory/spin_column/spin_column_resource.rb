#spin_column_resource.rb
require 'lims-api/core_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labellable_core_resource'
require 'lims-laboratory-app/laboratory/spin_column'
require 'lims-laboratory-app/laboratory/container/receptacle'
require 'lims-laboratory-app/laboratory/location_to_stream'

module Lims::LaboratoryApp
  module Laboratory
    class SpinColumn
      class SpinColumnResource < LabellableCoreResource

        include Lims::LaboratoryApp::Laboratory::Container::Receptacle
        include Lims::LaboratoryApp::Laboratory::LocationToStream

        def content_to_stream(s, mime_type)
          super(s, mime_type)
          location_to_stream(s, mime_type, object.location.attributes) if object.attributes[:location]
          s.add_key "aliquots"
          receptacle_to_stream(s, object, mime_type)
        end
      end
    end
  end
end
