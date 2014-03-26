require 'lims-api/core_action_resource'

require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/container/container_to_uuid'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class TransferTubesToTubes
        class TransferTubesToTubesResource < Lims::Api::CoreActionResource

          include Lims::LaboratoryApp::Laboratory::Container::ContainerToUuid

        end
      end
    end
  end
end
