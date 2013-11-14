# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/laboratory/sample/sample_persistor'
require 'lims-laboratory-app/laboratory/snp_assay/snp_assay_persistor'
require 'lims-laboratory-app/laboratory/oligo/oligo_persistor'

module Lims::LaboratoryApp
  module Laboratory
    # @abstract
    # Base for all Aliquot persistor.
    # Real implementation classes (e.g. Sequel::Aliquot) should
    # include the suitable persistor.
    class Aliquot
      (does "lims/core/persistence/persistable", :parents => [:sample,
          :snp_assay, {:name => :tag, :session_name => :oligo}
        ]).class_eval do

        alias filter_attributes_on_save_old filter_attributes_on_save
        def filter_attributes_on_save(attributes, *params)
          if Aliquot.unit(attributes[:type] == "ul") &&
            quantity=attributes[:quantity]
            attributes[:quantity] = quantity*1000
          end
          # out_of_bounds parameter is not saved into the database
          attributes.delete(:out_of_bounds)
          filter_attributes_on_save_old(attributes)
        end

        alias filter_attributes_on_load_old filter_attributes_on_load
        def filter_attributes_on_load(attributes, *params)

          if Aliquot.unit(attributes[:type] == "ul") &&
            quantity=attributes[:quantity]
            attributes[:quantity] = quantity/(quantity % 1000 == 0 ? 1000 : 1000.0)
          end
          filter_attributes_on_load_old(attributes)
        end
      end
    end
  end
end
