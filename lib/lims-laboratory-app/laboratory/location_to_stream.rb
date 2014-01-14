module Lims::LaboratoryApp
  module Laboratory
    module LocationToStream

      def location_to_stream(s, mime_type, location_attributes)
        s.add_key :location
        hash_to_stream(s, object.location.attributes, mime_type)
      end

    end
  end
end
