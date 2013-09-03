# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persist_association_trait'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/container/container_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_persistor'
require 'lims-laboratory-app/laboratory/flowcell'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Flowcell persistor.
    # Real implementation classes (e.g. Sequel::Flowcell) should
    # include the suitable persistor.
    class Flowcell
      (does "lims/core/persistence/persistable", :children => [
          {:name => :lane_aliquot, :deletable => true }
        ]).class_eval do


        def children_lane_aliquot(resource, children)
          resource.content.each_with_index do |lane, position|
            lane.each do |aliquot|
              lane_aliquot = self.class::LaneAliquot.new(resource, position, aliquot)
              state = @session.state_for(lane_aliquot)
              state.resource = lane_aliquot
              children << lane_aliquot
            end
          end
        end

        association_class "LaneAliquot" do
          attribute :flowcell, Flowcell, :relation => :parent
          attribute :position, Fixnum
          attribute :aliquot, Aliquot, :relation => :parent

          def on_load
            @flowcell[@position] << @aliquot
          end

          def invalid?
            !@flowcell[@position].include?(@aliquot)
          end
        end

        class self::LaneAliquot
          class LaneAliquotSequelPersistor < self::LaneAliquotPersistor
            include Lims::Core::Persistence::Sequel::Persistor
            def self.table_name
              :lanes
            end
          end
        end
      end
    end
  end
end
