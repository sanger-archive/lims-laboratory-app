require 'lims-api/struct_stream'

module Lims::LaboratoryApp
  module Labels
    module LabellableResourceShared
      def filtered_attributes
        super.mash do |k,v|
          case k
          when :labellable
            [:labellable_uuid,  @context.uuid_for(v)]
          else
            [k,v]
          end
        end
      end
    end
  end
end
