require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/labels/labellable'

# needs to require all label subclasses
require 'lims-laboratory-app/labels/sanger_barcode'

module Lims::LaboratoryApp
  module Labels
    class Labellable
      class LabelProxy
        include Lims::Core::Resource
        attribute :position, String
        attribute :labellable, Labellable
        attribute :label, Object

        def initialize(labellable, position, label=nil)
          @labellable = labellable
          @position = position
          @label = label
        end
        def keys 
          [@labellable.object_id, @position, @label.object_id]
        end
        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end
      end

      class LabellablePersistor < Lims::Core::Persistence::Persistor
        Model = Labels::Labellable

        def label
          @session.labellable_label
        end

        # Saves all children of a given Labellable
        def children(labellable)
          labellable.map do |position, label_object|
            LabelProxy.new(labellable, position)
          end
        end

        def filter_attributes_on_save(attributes)
          attributes.delete(:content)
          super(attributes)
        end

        # Loads all children of a given Labellable
        def load_children(states, *params)
          label.find_by(:labellable_id => states.map(&:id))
        end
          # We need to compact the value if it's an uuid (type = resource).
          # so that we can do a join with the uuid_resources table.
            def filter_attributes_on_save(attributes, *params)
              attributes.delete(:content)
              if attributes[:type] == "resource"
                name = attributes[:name]
                attributes[:name] = @session.pack_uuid(name)
              end
              attributes
            end

            # needs to uncompact uuid if it's a resource
            def filter_attributes_on_load(attributes, *params)
              if attributes[:type] == "resource"
                name = attributes[:name]
                attributes[:name] = @session.unpack_uuid(name)
              end
              attributes
            end
      end
      class LabelProxy 
        SESSION_NAME=:labellable_label
          def attributes
            @labellable[@position].attributes.tap do |att| 
              att[:position]=@position
              att[:labellable]=@labellable
            end

          end
        class LabelPersistor < Lims::Core::Persistence::Persistor
          Model = Labels::Labellable::LabelProxy
          def attribute_for(key)
            {labellable: 'labellable_id',
            }[key]
          end


          def new_from_attributes(attributes)
            labellable = @session.labellable[attributes.delete(:labellable_id)]
            position = attributes.delete(:position)
            super(attributes) do |att|
              label = Label.new(att)
              labellable[position] = label
              model.new(labellable, position)
            end
          end
        end

        class LabelSequelPersistor < LabelPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :labels
          end
          def new_from_attributesX(attributes)
            labellable = @session.labellable[attributes.delete(:labellable_id)]
            position = attributes.delete(:position)
            labellable[position] = Label.new(attributes)
          end

          end
        end
      end
    end
  end
