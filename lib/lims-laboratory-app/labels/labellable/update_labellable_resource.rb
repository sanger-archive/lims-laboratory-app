require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/update_labellable'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class UpdateLabellable
        class UpdateLabellableResource < Lims::Api::CoreActionResource
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
  end
end

