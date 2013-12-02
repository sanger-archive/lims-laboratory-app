# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-laboratory-app/laboratory/gel'
require 'lims-laboratory-app/container_persistor_trait'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Gel persistor.
    # Real implementation classes (e.g. Sequel::Gel) should
    # include the suitable persistor.
    class Gel
      does "lims/laboratory_app/container_persistor", 
       :element => :window_aliquot, 
       :table_name => :windows,
       :contained_class => Aliquot
    end
  end
end

