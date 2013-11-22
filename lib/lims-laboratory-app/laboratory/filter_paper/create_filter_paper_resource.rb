require 'lims-api/core_action_resource'
require 'lims-laboratory-app/laboratory/filter_paper'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class CreateFilterPaperResource < Lims::Api::CoreActionResource

        def filtered_attributes
          super.tap do |attributes|
            attributes[:aliquots].map! do |aliquot|
              aliquot.mash do |k,v|
                case k
                when "sample" then ["sample_uuid", @context.uuid_for(v)]
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
