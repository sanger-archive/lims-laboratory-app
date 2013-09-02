# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistable_trait'
require 'lims-laboratory-app/laboratory/sample'

module Lims
  module LaboratoryApp::Laboratory
    # @abstract
    # Base for all Sample persistor.
    # Real implementation classes (e.g. Sequel::Aliquot) should
    # include the suitable persistor.
    class Sample
      does "lims/core/persistence/persistable"
    end
  end
end
