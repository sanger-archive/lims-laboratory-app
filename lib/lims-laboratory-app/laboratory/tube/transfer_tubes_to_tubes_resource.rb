require 'lims-api/core_action_resource'
require 'lims-api/resources/container_to_uuid'

require 'lims-laboratory-app/laboratory/tube'

module Lims::Core
  module Laboratory
    class Tube
      class TransferTubesToTubes
        class TransferTubesToTubesResource < Lims::Api::CoreActionResource

          include Lims::Api::Resources::ContainerToUuid

        end
      end
    end
  end
end
