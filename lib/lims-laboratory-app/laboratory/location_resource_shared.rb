module Lims::LaboratoryApp
  module Laboratory
    module LocationResourceShared

      def location_to_stream(s, location)
        s.add_key "location"
        s.with_hash do
          location.attributes.each do |key, value|
            s.add_key key.to_s
            s.add_value value
          end
        end
      end

    end
  end
end
