require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'
require 'lims-laboratory-app/laboratory/sample/swap_samples'

module Lims::LaboratoryApp
  module Laboratory
    class Sample
      class SwapSamplesResource < Lims::Api::CoreActionResource

        def filtered_attributes
          super.tap do |attributes|
            attributes[:swap_samples] = attributes[:swap_samples].map.each do |element|
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
