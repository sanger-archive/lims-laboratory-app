require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/labels/labellable'
require 'lims-laboratory-app/labels/labellable/update_label'
require 'lims-laboratory-app/labels/labellable/labellable_resource_shared'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class UpdateLabel
        class UpdateLabelResource < Lims::Api::CoreActionResource
          include LabellableResourceShared
        end
      end
    end
  end
end
