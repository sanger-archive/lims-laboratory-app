require 'lims-laboratory-app/laboratory/fluidigm'
require 'lims-laboratory-app/container_persistor_trait'

require 'lims-laboratory-app/laboratory/aliquot/aliquot_persistor'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Fluidigm persistor.
    # Real implementation classes (e.g. Sequel::Fluidigm) should
    # include the suitable persistor.
    class Fluidigm
      does "lims/laboratory_app/container_persistor",
        :element => :fluidigm_well_aliquot,
        :parents => [{:name => :location, :deletable => true}],
        :table_name => :fluidigm_wells,
        :contained_class => Aliquot

    end
  end
end
