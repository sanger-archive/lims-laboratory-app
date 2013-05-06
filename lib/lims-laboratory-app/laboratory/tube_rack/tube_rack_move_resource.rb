require 'lims-api/core_action_resource'
require 'lims-api/resources/container_to_uuid'

require 'lims-laboratory-app/laboratory/tube_rack/tube_rack_move'

module Lims::LaboratoryApp
  module Laboratory
    class TubeRack
      class TubeRackMoveResource < Lims::Api::CoreActionResource

        include Lims::Api::Resources::ContainerToUuid

        # Overrides the default transfer method
        def transfer_method
          :moves
        end

      end
    end
  end
end
