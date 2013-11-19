module Lims::LaboratoryApp
  module Laboratory
    module MoveContentResourceShared
      def filtered_attributes
        super.tap do |attributes|
          attributes[:parameters] = attributes[:parameters].map.each do |element|
            element.mash do |k,v|
              case k
              when "resource" then ["resource_uuid", @context.uuid_for(v)]
              else [k,v]
              end
            end
          end
        end
      end
    end
  end
end
