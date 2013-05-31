require 'lims-api/core_action_resource'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class BulkCreateTube
        class BulkCreateTubeResource < Lims::Api::CoreActionResource

          def filtered_attributes
            super.tap do |attributes|
              attributes[:tubes].map! do |tube|
                tube.tap do |t|
                  t["aliquots"].map! do |aliquot|
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
