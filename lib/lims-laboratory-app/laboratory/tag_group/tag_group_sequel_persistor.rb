# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-laboratory-app/laboratory/tag_group/tag_group_persistor'
require 'lims-core/persistence/sequel/persistor'

module Lims::LaboratoryApp
  module Laboratory
    # Not a tag_group but a tag_group persistor.
    class TagGroup
      class TagGroupSequelPersistor < TagGroupPersistor
        include Lims::Core::Persistence::Sequel::Persistor


        def save_raw_association(tag_group_id, oligo_id, position)
          association.dataset.insert(:tag_group_id => tag_group_id,
            :position => position,
            :oligo_id  => oligo_id)
        end

        def delete_children(id, group)
          return unless id.present?
          association.dataset.filter(primary_key => id).delete
        end
      end


      module Association
        class AssociationSequelPersistor < AssociationPersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :tag_group_associations
          end

          # Load each oligos and pass them to the block
          # @param [Id] group_id id of the Tag group
          # @yieldparam [Oligo] oligo Object created or loaded
          # @yieldparam [Fixnum] position the index of Oligo in the TagGroup.
          def load_oligos(group_id, &block)
            dataset.join(:oligos, :id => :oligo_id).filter(:tag_group_id => group_id).order(:position).each do |att|
              position = att.delete(:position)
              oligo_id = att.delete(:oligo_id)
              att.delete(:group_id)
              oligo = @session.oligo.get_or_create_single_model(oligo_id, att)
              block.call(oligo, position) if block
            end
          end
        end
      end
    end
  end
end
