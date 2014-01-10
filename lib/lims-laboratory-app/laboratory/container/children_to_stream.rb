require 'lims-laboratory-app/laboratory/location_resource_shared'

module Lims::LaboratoryApp
  module Laboratory
    module Container::ChildrenToStream
      include Lims::LaboratoryApp::Laboratory::LocationResourceShared

      def children_to_stream(s, mime_type)
        super(s, mime_type)
        location_to_stream(s, object.attributes[:location]) if object.attributes[:location]
        s.add_key elements_name
        receptacles_to_stream(s, mime_type)
      end
    end
  end
end
