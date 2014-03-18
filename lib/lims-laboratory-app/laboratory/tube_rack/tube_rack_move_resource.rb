require 'lims-api/core_action_resource'

require 'lims-laboratory-app/laboratory/tube_rack/tube_rack_move'
require 'lims-laboratory-app/laboratory/container/container_to_uuid'

module Lims::LaboratoryApp
  module Laboratory
    class TubeRack
      class TubeRackMoveResource < Lims::Api::CoreActionResource

        include Lims::LaboratoryApp::Laboratory::Container::ContainerToUuid

        # Overrides the default transfer method
        def transfer_method
          :moves
        end

      end
    end
  end
end
