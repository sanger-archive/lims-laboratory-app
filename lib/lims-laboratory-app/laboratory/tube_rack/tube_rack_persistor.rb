# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-laboratory-app/laboratory/tube_rack'
require 'lims-laboratory-app/container_persistor_trait'
require 'lims-laboratory-app/labels/labellable/eager_labellable_loading'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all TubeRack persistor.
    # Real implementation classes (e.g. Sequel::TubeRack) should
    # include the suitable persistor.
    class TubeRack
      does "lims/laboratory_app/container_persistor", :element => :tube_rack_slot, :table_name => :tube_rack_slots, :contained_class => Tube, :deletable => false

      # Overwrite some behavior
      class TubeRackPersistor
        include Labels::Labellable::EagerLabellableLoading

        def children_tube_rack_slot(resource, children)
          resource.content.each_with_index.each do |tube, position|
            next unless tube
            slot = TubeRackSlot.new(resource, position, tube)
            state = @session.state_for(slot)
            state.resource = slot
            children << slot
          end
        end
        def belongs_to_tube_rack?(tube)
          false
        end

        class TubeRackSlot
          def invalid?
            @tube_rack[@position] != @tube || @tube == nil
          end

          def on_load
            @tube_rack[@position] = @tube
          end
        end
      end

      class TubeRackSequelPersistor < TubeRackPersistor
        include Lims::Core::Persistence::Sequel::Persistor
        def belongs_to_tube_rack?(tube)
          tube_id = @session.id_for(tube)
          @session.tube_rack_slot_persistor.dataset.where(:tube_id => tube_id).count > 0
        end
      end
    end
  end
end


