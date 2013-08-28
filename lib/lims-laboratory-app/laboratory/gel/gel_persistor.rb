# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/container/container_persistor'
require 'lims-laboratory-app/laboratory/container/container_element_persistor'
require 'lims-laboratory-app/laboratory/gel'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Gel persistor.
    # Real implementation classes (e.g. Sequel::Gel) should
    # include the suitable persistor.
    class Gel
      class WindowAliquot
        NOT_IN_ROOT = true
        include Lims::Core::Resource
        attribute :gel, Gel
        attribute :position, Fixnum
        attribute :aliquot, Aliquot

        def initialize(gel, position=nil, aliquot=nil)
          @gel=gel
          @position=position
          @aliquot=aliquot
        end

        def keys 
          [@gel.object_id, @position, @aliquot.object_id]
        end
        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end
      end

      class GelPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::Gel

        include Container::ContainerPersistor

        # calls the correct element method
        def element
          window
        end

        def window
          @session.gel_window
        end

        def children(resource)
          [].tap do |list|
            resource.content.each_with_index do |window, position|
              window.each do |aliquot|
                window_aliquot = WindowAliquot.new(resource, position, aliquot)
                state = state_for(window_aliquot)
                state.resource = window_aliquot
                list << window_aliquot
              end
            end
          end
        end

        def deletable_children(resource)
          children(resource)
        end

        def load_children(states, *params)
          #load windows
          window.find_by(:gel_id => states.map(&:id))
        end
      end

      # Base for all Window persistor.
      # Real implementation classes (e.g. Sequel::Window) should
      # include the suitable persistor.
      class WindowAliquot
        SESSION_NAME = :gel_window
        class WindowPersistor < Lims::Core::Persistence::Persistor
          Model = Laboratory::Gel::WindowAliquot

          include Container::ContainerElementPersistor
          def attribute_for(key)
            {gel: 'gel_id',
              aliquot: 'aliquot_id'
            }[key]
          end

          def new_from_attributes(attributes)
            id = attributes.delete(primary_key)
            gel = @session.gel[attributes[:gel_id]]
            position = attributes[:position]
            aliquot = @session.aliquot[attributes[:aliquot_id]]
            gel[position] << aliquot
            state_for_id(id).resource = WindowAliquot.new(gel, position, aliquot)
          end

          def parents_for_attributes(attributes)
            [@session.aliquot.state_for_id(attributes[:aliquot_id])]
          end

          def invalid_resource?(resource)
            !resource.gel[resource.position].include? resource.aliquot
          end


        end
        class WindowSequelPersistor < WindowPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :windows
          end
        end
      end
    end
  end
end
