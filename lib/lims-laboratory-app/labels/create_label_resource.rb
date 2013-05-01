require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/create_label'

module Lims::LaboratoryApp
  module Labels
    class CreateLabel
      class CreateLabelResource < Lims::Api::CoreActionResource
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

