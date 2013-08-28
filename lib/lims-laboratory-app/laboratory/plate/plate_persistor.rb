# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/container/container_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_persistor'
require 'lims-laboratory-app/laboratory/plate'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Plate persistor.
    # Real implementation classes (e.g. Sequel::Plate) should
    # include the suitable persistor.
    class Plate
      class WellAliquot
        NOT_IN_ROOT = true
        include Lims::Core::Resource
        attribute :plate, Plate
        attribute :position, Fixnum
        attribute :aliquot, Aliquot

        def initialize(plate, position=nil, aliquot=nil)
          @plate=plate
          @position=position
          @aliquot=aliquot
        end

        def attributes
          {plate: @plate, position: @position, aliquot: aliquot}
        end

        def keys 
          [@plate.object_id, @position, @aliquot.object_id]
        end
        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end
      end

      class PlatePersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::Plate

        include Container::ContainerPersistor

        # calls the correct element method
        def element
          well
        end

        def well
          @session.plate_well
        end

        def children(resource)
          [].tap do |list|
            resource.content.each_with_index do |well, position|
              well.each do |aliquot|
                well_aliquot = WellAliquot.new(resource, position, aliquot)
                state = state_for(well_aliquot)
                state.resource = well_aliquot
                list << well_aliquot
              end
            end
          end
        end

        def deletable_children(resource)
          children(resource)
        end


        def load_children(states, *params)
          #load wells
          well.find_by(:plate_id => states.map(&:id))
        end
      end

      # Base for all Well persistor.
      # Real implementation classes (e.g. Sequel::Well) should
      # include the suitable persistor.
      class WellAliquot
        SESSION_NAME = :plate_well
        class WellPersistor < Lims::Core::Persistence::Persistor
          Model = Laboratory::Plate::WellAliquot

          include Container::ContainerElementPersistor
          def attribute_for(key)
            {plate: 'plate_id',
              aliquot: 'aliquot_id'
            }[key]
          end

          def new_from_attributes(attributes)
            super(attributes) do 
              plate = @session.plate[attributes[:plate_id]]
              position = attributes[:position]
              aliquot = @session.aliquot[attributes[:aliquot_id]]
              plate[position] << aliquot
              WellAliquot.new(plate, position, aliquot)
            end
          end

          def parents_for_attributes(attributes)
            [@session.aliquot.state_for_id(attributes[:aliquot_id])]
          end

          def invalid_resource?(resource)
            !resource.plate[resource.position].include?(resource.aliquot)
          end

          # don't add object to the session
          # otherwise "link object" will be saved even if they
          # don't exist anymore.
          def on_object_load(state)
          end

        end
        class WellSequelPersistor < WellPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :wells
          end
        end
      end
    end
  end
end
