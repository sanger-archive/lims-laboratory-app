require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-api/core_action_resource'
require 'lims-api/resources/container_to_uuid'
require 'lims-api/struct_stream'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class TransferMultipleFilterPapersToWellsResource < Lims::Api::CoreActionResource

        include Lims::Api::Resources::ContainerToUuid

      end
    end
  end
end
