require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/laboratory/assay'

module Lims
  module LaboratoryApp::Laboratory
    # @abstract
    # Base for all Assay persistor.
    class Assay
      does "lims/core/persistence/persistable"
    end
  end
end
