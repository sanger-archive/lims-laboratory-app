# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/organization/user'

module Lims::LaboratoryApp
  module Organization
    # Base for all User persistors.
    class User
      class UserPersistor < Lims::Core::Persistence::Persistor
        Model = Organization::User
      end
    end
  end
end
