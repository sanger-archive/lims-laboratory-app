# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/container_persistor_trait'

require 'lims-laboratory-app/laboratory/aliquot/aliquot_persistor'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Plate persistor.
    # Real implementation classes (e.g. Sequel::Plate) should
    # include the suitable persistor.
    class Plate
      does "lims/laboratory_app/container_persistor", :element => :well_aliquot, :table_name => :wells,
      :contained_class => Aliquot
    end
  end
end


