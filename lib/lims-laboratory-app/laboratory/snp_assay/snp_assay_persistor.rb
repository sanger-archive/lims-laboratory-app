require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/laboratory/snp_assay'

module Lims
  module LaboratoryApp::Laboratory
    # @abstract
    # Base for all Assay persistor.
    class SnpAssay
      does "lims/core/persistence/persistable"
    end
  end
end
