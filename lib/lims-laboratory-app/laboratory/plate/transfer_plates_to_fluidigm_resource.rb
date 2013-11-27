require 'lims-api/core_action_resource'

require 'lims-laboratory-app/laboratory/plate/transfer_plates_to_fluidigm'
require 'lims-laboratory-app/laboratory/container/container_to_uuid'

module Lims::LaboratoryApp
  module Laboratory
    class Plate
      class TransferPlatesToFluidigmResource < Lims::Api::CoreActionResource

        include Lims::LaboratoryApp::Laboratory::Container::ContainerToUuid

      end
    end
  end
end
