require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/container_persistor_trait'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper

      # This trait is defining the persistor layer of the Filter Paper class.
      does "lims/laboratory_app/container_persistor",
        :element => :location_aliquot,
        :table_name => :locations,
        :contained_class => Aliquot

    end
  end
end
