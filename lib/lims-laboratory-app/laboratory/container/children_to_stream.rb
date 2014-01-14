require 'lims-laboratory-app/laboratory/location_to_stream'

module Lims::LaboratoryApp
  module Laboratory
    module Container::ChildrenToStream
      include Lims::LaboratoryApp::Laboratory::LocationToStream

      def children_to_stream(s, mime_type)
        super(s, mime_type)
        location_to_stream(s, mime_type, object.location.attributes) if object.attributes[:location]
        s.add_key elements_name
        receptacles_to_stream(s, mime_type)
      end
    end
  end
end
