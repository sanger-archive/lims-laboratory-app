require 'lims-api/core_action_resource'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class BulkCreateFilterPaper
        class BulkCreateFilterPaperResource < Lims::Api::CoreActionResource

          def filtered_attributes
            super.tap do |attributes|
              attributes[:filter_papers].map! do |filter_paper|
                filter_paper.tap do |fp|
                  fp["locations_description"].each do |position, aliquots|
                    aliquots.map! do |aliquot|
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
      end
    end
  end
end
