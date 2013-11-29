# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persist_association_trait'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/container_persistor_trait'
require 'lims-laboratory-app/laboratory/flowcell'
require 'lims-laboratory-app/laboratory/aliquot/aliquot_persistor'
require 'lims-laboratory-app/labels/labellable/eager_labellable_loading'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Flowcell persistor.
    # Real implementation classes (e.g. Sequel::Flowcell) should
    # include the suitable persistor.
    class Flowcell
      does "lims/laboratory_app/container_persistor", :element => :lane_aliquot,
      :contained_class => Aliquot,
      :table_name => :lanes

      class FlowcellPersistor
        include Lims::LaboratoryApp::Labels::Labellable::EagerLabellableLoading
      end
    end
  end
end

