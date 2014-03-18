require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/container/container_to_uuid'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class TransferMultipleFilterPapersToWellsResource < Lims::Api::CoreActionResource

        include Lims::LaboratoryApp::Laboratory::Container::ContainerToUuid

      end
    end
  end
end
