# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/organization/user'

module Lims::LaboratoryApp
  module Organization
    # Base for all User persistors.
    class User
      does "lims/core/persistence/persistable"
    end
  end
end
