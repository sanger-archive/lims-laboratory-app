require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'
require 'lims-laboratory-app/laboratory/snp_assay/move_snp_assays'
require 'lims-laboratory-app/laboratory/move_content_resource_shared'

module Lims::LaboratoryApp
  module Laboratory
    class SnpAssay
      class MoveSnpAssaysResource < Lims::Api::CoreActionResource

        include MoveContentResourceShared

      end
    end
  end
end
