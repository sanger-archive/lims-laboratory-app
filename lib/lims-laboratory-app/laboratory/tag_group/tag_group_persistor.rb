# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/tag_group'
require 'lims-laboratory-app/laboratory/oligo/all'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Plate persistor.
    # Real implementation classes (e.g. Sequel::Plate) should
    # include the suitable persistor.
    class TagGroup
      class TagGroupPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::TagGroup

        def children(resource)
          [].tap do |list|
            resource.each_with_index do |oligo, position|
              group_oligo = TagGroupOligo.new(resource, position, oligo)
              state = @session.tag_group_oligo.state_for(group_oligo)
              list << state.resource = group_oligo
            end
          end
        end

        def deletable_children(resource)
          children(resource)
        end

        # Save all children of the given group
        # @param  id object identifier
        # @param [Laboratory::TagGroup] group
        # @return [Boolean]
        def save_childrenX(id, group)
          group.each_with_index do |oligo, position|
            next unless oligo
            save_as_aggregation(id, oligo, position)
          end
        end

        # Load all children of the given group
        # Loaded object are automatically added to the session.
        # @param  id object identifier
        # @param [Laboratory::Plate] group
        # @return [Laboratory::Plate, nil] 
        #
        def load_children(states, *params)
          tag_group_oligo.find_by(:tag_group_id => states.map(&:id))
        end

        def tag_group_oligo
          @session.tag_group_oligo
        end
      end

      class TagGroupOligo
        SESSION_NAME = :tag_group_oligo
        include Lims::Core::Resource
        attribute :tag_group, TagGroup
        attribute :position, Fixnum
        attribute :oligo, Oligo

        def initialize(group, position, oligo=nil)
          @tag_group = group
          @position = position
          @oligo = oligo
        end

        def attributes
          {tag_group: @tag_group, position: @position, oligo: @oligo }
        end

        def keys
          [@tag_group.object_id, @position, @oligo]
        end

        def hash
          keys.hash
        end

        def eql?(other)
          keys == other.keys
        end

        class TagGroupOligoPersistor < Lims::Core::Persistence::Persistor
          Model = Laboratory::TagGroup::TagGroupOligo

          def attribute_for(key)
            {tag_group: 'tag_group_id',
              oligo: 'oligo_id'
            }[key]
          end

          def new_from_attributes(attributes)
            super(attributes) do |att|
              tag_group = @session.tag_group[att[:tag_group_id]]
              position = att[:position]
              oligo = @session.oligo[att[:oligo_id]]
              tag_group[position] = oligo
              TagGroupOligo.new(tag_group, position, oligo)
            end
          end

          def parents_for_attributes(attributes)
            [@session.oligo.state_for_id(attributes[:oligo_id])]
          end

          def invalid_resource?(resource)
            resource.tag_group[resource.position] != resource.oligo
          end
        end
        class TagGroupOligoSequelPersistor < TagGroupOligoPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :tag_group_associations
          end
        end
      end
    end
  end
end
