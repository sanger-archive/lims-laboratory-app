# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
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
      class LaneAliquot
        NOT_IN_ROOT = true
        include Lims::Core::Resource
        attribute :flowcell, Flowcell
        attribute :position, Fixnum
        attribute :aliquot, Aliquot

        def initialize(flowcell, position=nil, aliquot=nil)
          @flowcell=flowcell
          @position=position
          @aliquot=aliquot
        end

        def keys 
          [@flowcell.object_id, @position, @aliquot.object_id]
        end
        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end
      end

      class FlowcellPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::Flowcell

        include Container::ContainerPersistor

        # calls the correct element method
        def element
          lane
        end

        def lane
          @session.flowcell_lane
        end

        def children(resource)
          [].tap do |list|
            resource.content.each_with_index do |lane, position|
              lane.each do |aliquot|
                lane_aliquot = LaneAliquot.new(resource, position, aliquot)
                state = state_for(lane_aliquot)
                state.resource = lane_aliquot
                list << lane_aliquot
              end
            end
          end
        end

        def deletable_children(resource)
          children(resource)
        end

        def load_children(states, *params)
          #load lanes
          lane.find_by(:flowcell_id => states.map(&:id))
        end
      end

      # Base for all Lane persistor.
      # Real implementation classes (e.g. Sequel::Lane) should
      # include the suitable persistor.
      class LaneAliquot
        SESSION_NAME = :flowcell_lane
        class LanePersistor < Lims::Core::Persistence::Persistor
          Model = Laboratory::Flowcell::LaneAliquot

          include Container::ContainerElementPersistor
          def attribute_for(key)
            {flowcell: 'flowcell_id',
              aliquot: 'aliquot_id'
            }[key]
          end

          def new_from_attributes(attributes)
            id = attributes.delete(primary_key)
            flowcell = @session.flowcell[attributes[:flowcell_id]]
            position = attributes[:position]
            aliquot = @session.aliquot[attributes[:aliquot_id]]
            flowcell[position] << aliquot
            state_for_id(id).resource = LaneAliquot.new(flowcell, position, aliquot)
          end

          def parents_for_attributes(attributes)
            [@session.aliquot.state_for_id(attributes[:aliquot_id])]
          end
        def invalid_resource?(resource)
          !resource.flowcell[resource.position].include? resource.aliquot
        end
          
        end
        class LaneSequelPersistor < LanePersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :lanes
          end
        end
      end
    end
  end
end
