require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'
require 'lims-laboratory-app/laboratory/snp_assay/move_snp_assays'

module Lims::LaboratoryApp
  module Laboratory
    class SnpAssay
      class MoveSnpAssaysResource < Lims::Api::CoreActionResource

        def filtered_attributes
          super.tap do |attributes|
            attributes[:parameters] = attributes[:parameters].map.each do |element|
              element.mash do |k,v|
                case k
                when "resource" then ["resource_uuid", @context.uuid_for(v)]
                else [k,v]
                end
              end
            end
          end
        end
      end
    end
  end
end
