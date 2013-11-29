require 'lims-laboratory-app/laboratory/fluidigm'
require 'lims-laboratory-app/container_persistor_trait'

require 'lims-laboratory-app/laboratory/aliquot/aliquot_persistor'
require 'lims-laboratory-app/labels/labellable/eager_labellable_loading'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Fluidigm persistor.
    # Real implementation classes (e.g. Sequel::Fluidigm) should
    # include the suitable persistor.
    class Fluidigm
      does "lims/laboratory_app/container_persistor", 
        :element => :fluidigm_well_aliquot, 
        :table_name => :fluidigm_wells,
        :contained_class => Aliquot
        
      class FluidigmPersistor
        include Lims::LaboratoryApp::Labels::Labellable::EagerLabellableLoading
      end
    end
  end
end
