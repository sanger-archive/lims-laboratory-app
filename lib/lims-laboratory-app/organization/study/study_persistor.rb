# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/organization/study'

module Lims::LaboratoryApp
  module Organization
    # Base for all Study persistors.
    class Study
      class StudyPersistor < Persistence::Persistor
        Model = Organization::Study
      end
    end
  end
end
