# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/container/container_persistor'
require 'lims-laboratory-app/laboratory/tube/tube_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_persistor'
require 'lims-laboratory-app/laboratory/tube_rack'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all TubeRack persistor.
    # Real implementation classes (e.g. Sequel::TubeRack) should
    # include the suitable persistor.
    class TubeRack
      class SlotTube
        NOT_IN_ROOT = true
        include Lims::Core::Resource
        attribute :tube_rack, TubeRack
        attribute :position, Fixnum
        attribute :tube, Tube

        def initialize(tube_rack, position=nil, tube=nil)
          @tube_rack=tube_rack
          @position=position
          @tube=tube
        end

        def keys 
          [@tube_rack.object_id, @position, @tube.object_id]
        end
        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end
      end

      class TubeRackPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::TubeRack

        include Container::ContainerPersistor

        # calls the correct element method
        def element
          slot
        end

        def slot
          @session.tube_rack_slot
        end

        def children(resource)
          [].tap do |list|
            resource.content.each_with_index do |tube, position|
              next unless tube
              slot_tube = SlotTube.new(resource, position, tube)
              state = state_for(slot_tube)
              state.resource = slot_tube
              list << slot_tube
            end
          end
        end

        def deletable_children(resource)
          children(resource)
        end

        def load_children(states, *params)
          #load slots
          slot.find_by(:tube_rack_id => states.map(&:id))
        end
      end

      # Base for all Slot persistor.
      # Real implementation classes (e.g. Sequel::Slot) should
      # include the suitable persistor.
      class SlotTube
        SESSION_NAME = :tube_rack_slot
        class SlotPersistor < Lims::Core::Persistence::Persistor
          Model = Laboratory::TubeRack::SlotTube

          include Container::ContainerElementPersistor
          def attribute_for(key)
            {tube_rack: 'tube_rack_id',
              tube: 'tube_id'
            }[key]
          end

          def new_from_attributes(attributes)
            id = attributes.delete(primary_key)
            tube_rack = @session.tube_rack[attributes[:tube_rack_id]]
            position = attributes[:position]
            tube = @session.tube[attributes[:tube_id]]
            debugger if tube_rack[position]
            tube_rack[position]=  tube
            state_for_id(id).resource = SlotTube.new(tube_rack, position, tube)
          end

          def parents_for_attributes(attributes)
            [@session.tube.state_for_id(attributes[:tube_id])]
          end

          def invalid_resource?(resource)
            !resource.tube_rack[resource.position].equal?(resource.tube) || resource.tube == nil
          end

        end
        class SlotSequelPersistor < SlotPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :tube_rack_slots
          end
        end
      end
    end
  end
end
