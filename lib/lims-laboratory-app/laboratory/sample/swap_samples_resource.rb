require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'
require 'lims-laboratory-app/laboratory/sample/swap_samples'
require 'lims-laboratory-app/laboratory/move_content_resource_shared'

module Lims::LaboratoryApp
  module Laboratory
    class Sample
      class SwapSamplesResource < Lims::Api::CoreActionResource

        include MoveContentResourceShared

      end
    end
  end
end
