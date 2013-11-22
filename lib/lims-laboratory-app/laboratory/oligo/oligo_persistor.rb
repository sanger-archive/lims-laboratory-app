# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/laboratory/oligo'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Plate persistor.
    # Real implementation classes (e.g. Sequel::Plate) should
    # include the suitable persistor.
    class Oligo
      does "lims/core/persistence/persistable"
    end
  end
end
