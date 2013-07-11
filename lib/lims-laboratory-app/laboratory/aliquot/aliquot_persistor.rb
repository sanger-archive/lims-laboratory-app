# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/laboratory/sample/sample_persistor'
require 'lims-laboratory-app/laboratory/oligo/oligo_persistor'

module Lims::LaboratoryApp
  module Laboratory
    # @abstract
    # Base for all Aliquot persistor.
    # Real implementation classes (e.g. Sequel::Aliquot) should
    # include the suitable persistor.
    class Aliquot
      class AliquotPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::Aliquot

        def attribute_for(key)
          {sample: 'sample_id', 
            tag: 'tag_id'}[key]
        end
        def filter_attributes_on_load(attributes)
          attributes.mash do |k, v|
            case k
            when :sample_id then [:sample, @session.sample[v]]
            when :tag_id then [:tag, @session.oligo[v]]
            else [k,v]
            end
          end
        end
        def parents_for_attributes(attributes)
          [@session.sample.state_for_id(attributes[:sample_id]),
            @session.oligo.state_for_id(attributes[:tag_id])]
        end
      end

    end
  end
end
