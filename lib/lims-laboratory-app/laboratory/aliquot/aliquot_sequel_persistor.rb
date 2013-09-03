# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-laboratory-app/laboratory/aliquot/aliquot_persistor'
require 'lims-laboratory-app/laboratory/oligo/oligo_persistor'
require 'lims-core/persistence/sequel/persistor'

module Lims::LaboratoryApp
  module Laboratory
    # Not a aliquot but a aliquot persistor.
    class Aliquot
      class AliquotSequelPersistor < AliquotPersistor
        include Lims::Core::Persistence::Sequel::Persistor
        def self.table_name
          :aliquots
        end

        def filter_attributes_on_save(attributes)
          attributes.mash do |k,v|
            case k
            when :tag then [:tag_id, @session.id_for!(v)]
            when :sample then [:sample_id, @session.id_for!(v)]
            when :quantity
              if Aliquot.unit(attributes[:type]) == "ul"
                [k, v*1000]
              else
                [k, v]
              end
            else [k, v]
            end
          end
        end

        def filter_attributes_on_load(attributes)
          attributes.mash do |k,v|
            case k
            when :tag_id then [:tag, @session.oligo[v]]
            when :sample_id then [:sample, @session.sample[v]]
            when :quantity
              if Aliquot.unit(attributes[:type]) == "ul"
                [k, v/1000.0]
              else
                [k, v]
              end
            else [k, v]
            end
          end
        end

      end
    end
  end
end
