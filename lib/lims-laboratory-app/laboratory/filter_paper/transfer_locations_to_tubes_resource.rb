require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-api/core_action_resource'
require 'lims-api/resources/container_to_uuid'
require 'lims-api/struct_stream'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # The JSON resource file for the TransferLocationsToTubes operation
      class TransferLocationsToTubesResource < Lims::Api::CoreActionResource

        include Lims::Api::Resources::ContainerToUuid

        def filtered_attributes
          replace_attributes_resources_with_uuid(super)
        end

      end
    end
  end
end
