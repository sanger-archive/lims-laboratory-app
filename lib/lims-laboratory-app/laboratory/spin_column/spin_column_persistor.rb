# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/spin_column'
require 'lims-laboratory-app/laboratory/aliquot/all'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all SpinColumn persistor.
    # Real implementation classes (e.g. Sequel::SpinColumn) should
    # include the suitable persistor.
    class SpinColumn
      class SpinColumnAliquot
        include Lims::Core::Resource
        attribute :spin_column, SpinColumn
        attribute :aliquot, Aliquot

        def initialize(spin_column, aliquot=nil)
          @spin_column=spin_column
          @aliquot=aliquot
        end

        def keys
          [@spin_column.object_id, @aliquot.object_id]
        end

        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end

        SESSION_NAME = :spin_column_persistor_aliquot
        class SpinColumnAliquotPersistor < Lims::Core::Persistence::Persistor
          Model = SpinColumnAliquot
          def attribute_for(key)
            {spin_column: 'spin_column_id',
              aliquot: 'aliquot_id'
            }[key]
          end

        def delete_resource?(resource)
          invalid_resource?(resource)
        end
        def invalid_resource?(resource)
          !resource.spin_column.include? resource.aliquot
        end


          def new_from_attributes(attributes)
            spin_column = @session.spin_column[attributes.delete(:spin_column_id)]
            aliquot = @session.aliquot[attributes.delete(:aliquot_id)]
            spin_column << aliquot
            super(attributes) do |att|
              model.new(spin_column, aliquot)
            end
          end

          def parents_for_attributes(attributes)
            [@session.aliquot.state_for_id(attributes[:aliquot_id])]
          end
        end

        class SpinColumnAliquotSequelPersistor < SpinColumnAliquotPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :spin_column_aliquots
          end
        end
      end
      class SpinColumnPersistor < Lims::Core::Persistence::Persistor
        # this module is here only to give 'parent' class for the persistor
        # to be associated 
        Model = Laboratory::SpinColumn

        def  spin_column_aliquot
          @session.spin_column_persistor_aliquot
        end

        def children(resource)
          resource.map do |aliquot|
            SpinColumnAliquot.new(resource, aliquot)
          end
        end

        # Load all children of the given spin_column
        # Loaded object are automatically added to the session.
        # @param  id object identifier
        # @param [Laboratory::SpinColumn] spin_column
        # @return [Laboratory::SpinColumn, nil] 
        #
        def load_children(states)
          spin_column_aliquot.find_by(:spin_column_id => states.map(&:id))
        end
      end
    end
  end
end
