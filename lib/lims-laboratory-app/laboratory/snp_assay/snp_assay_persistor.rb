require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/laboratory/snp_assay'
require 'lims-laboratory-app/labels/labellable/eager_labellable_loading'

module Lims
  module LaboratoryApp::Laboratory
    # @abstract
    # Base for all Assay persistor.
    class SnpAssay
      (does "lims/core/persistence/persistable").class_eval do
        include Lims::LaboratoryApp::Labels::Labellable::EagerLabellableLoading
      end
    end
  end
end
