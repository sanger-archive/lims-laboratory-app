# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en
require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/organization/batch'

module Lims::LaboratoryApp
  module Organization
    class Batch
      does "lims/core/persistence/persistable"
    end
  end
end
