# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/laboratory/sample/sample_persistor'

module Lims::LaboratoryApp
  module Laboratory
    # @abstract
    # Base for all Aliquot persistor.
    # Real implementation classes (e.g. Sequel::Aliquot) should
    # include the suitable persistor.
    class Aliquot
      class AliquotPersistor < Lims::Core::Persistence::Persistor
        Model = Laboratory::Aliquot
      end
    end
  end
end
