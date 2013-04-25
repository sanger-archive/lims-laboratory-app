# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en
require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/organization/batch'

module Lims::LaboratoryApp
  module Organization
    class Batch
      class BatchPersistor < Lims::Core::Persistence::Persistor
        Model = Organization::Batch
      end
    end
  end
end
