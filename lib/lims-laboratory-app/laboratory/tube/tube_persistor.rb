# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/aliquot/all'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Tube persistor.
    # Real implementation classes (e.g. Sequel::Tube) should
    # include the suitable persistor.
    class Tube
      class TubeAliquot
        NOT_IN_ROOT = true
        include Lims::Core::Resource
        attribute :tube, Tube
        attribute :aliquot, Aliquot

        def initialize(tube, aliquot=nil)
          @tube=tube
          @aliquot=aliquot
        end

        def keys
          [@tube.object_id, @aliquot.object_id]
        end

        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end

        SESSION_NAME = :tube_persistor_aliquot
        class TubeAliquotPersistor < Lims::Core::Persistence::Persistor
          Model = TubeAliquot
          def attribute_for(key)
            {tube: 'tube_id',
              aliquot: 'aliquot_id'
            }[key]
          end

        def invalid_resource?(resource)
          !resource.tube.include? resource.aliquot
        end


          def new_from_attributes(attributes)
            tube = @session.tube[attributes.delete(:tube_id)]
            aliquot = @session.aliquot[attributes.delete(:aliquot_id)]
            tube << aliquot
            super(attributes) do |att|
              model.new(tube, aliquot)
            end
          end

          def parents_for_attributes(attributes)
            [@session.aliquot.state_for_id(attributes[:aliquot_id])]
          end
        end

        class TubeAliquotSequelPersistor < TubeAliquotPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :tube_aliquots
          end
        end
      end
      class TubePersistor < Lims::Core::Persistence::Persistor
        # this module is here only to give 'parent' class for the persistor
        # to be associated 
        Model = Laboratory::Tube

        def  tube_aliquot
          @session.tube_persistor_aliquot
        end

        def children(resource)
          resource.map do |aliquot|
            TubeAliquot.new(resource, aliquot)
          end
        end

        def deletable(resource)
          children(resource)
        end

        # Load all children of the given tube
        # Loaded object are automatically added to the session.
        # @param  id object identifier
        # @param [Laboratory::Tube] tube
        # @return [Laboratory::Tube, nil] 
        #
        def load_children(states)
          tube_aliquot.find_by(:tube_id => states.map(&:id))
        end
      end
    end
  end
end
