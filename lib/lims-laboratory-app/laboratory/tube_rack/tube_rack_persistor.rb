# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-laboratory-app/laboratory/tube_rack'
require 'lims-laboratory-app/laboratory/container/container_persistor_trait'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all TubeRack persistor.
    # Real implementation classes (e.g. Sequel::TubeRack) should
    # include the suitable persistor.
    class TubeRack
      does "lims/laboratory_app/laboratory/container/container_persistor", :element => :tube_slot, :table_name => :tube_rack_slots, :contained_class => Tube

      # Overwrite some behavior
      class TubeRackPersistor
        def children_tube_slot(resource, children)
          resource.content.each_with_index.each do |tube, position|
            next unless tube
            slot = TubeSlot.new(resource, position, tube)
            state = @session.state_for(slot)
            state.resource = slot
            children << slot
          end
        end

        class TubeSlot
          def invalid?
            @tube_rack[@position] != @tube || @tube == nil
          end

          def on_load
            @tube_rack[@position] = @tube
          end
        end
      end
    end
  end
end


