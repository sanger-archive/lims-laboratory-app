require 'lims-api/core_action_resource'
require 'lims-api/struct_stream'

require 'lims-laboratory-app/laboratory/tube_rack'
require 'lims-laboratory-app/laboratory/tube_rack/update_tube_rack'

module Lims::LaboratoryApp
  module Laboratory
    class TubeRack
      class UpdateTubeRackResource < Lims::Api::CoreActionResource

        def self.map_tubes(tubes, &block)
          tubes.update_values do |tube_data|
            if tube_data.is_a?(Hash)
              tube_data = tube_data.mash do |k,v|
                case k
                when "tube_uuid" then ["tube", block[v]]
                else [k,v]
                end
              end
            else
              tube_data = block[tube_data]
            end
          end unless tubes.nil?
        end

        def self.filter_attributes_on_create(attributes, context, session)
          super.tap do |new_attributes|
            map_tubes(new_attributes["tubes"]) { |v| session[v] }  
          end
        end

        def filtered_attributes
          super.tap do |attributes|
            self.class.map_tubes(attributes[:tubes]) { |v| @context.uuid_for(v) || v }
          end
        end
      end
    end
  end
end
