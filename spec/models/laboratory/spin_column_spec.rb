# Spec requirements
require 'models/laboratory/located_examples'
require 'models/laboratory/location_shared'
require 'models/laboratory/receptacle_examples'
require 'models/labels/labellable_examples'

# Model requirement
require 'lims-laboratory-app/laboratory/spin_column'

module Lims::LaboratoryApp::Laboratory
  describe SpinColumn, :spin_column => true, :laboratory => true  do
    it_behaves_like "located" 
    it_behaves_like "receptacle"
    it_behaves_like "labellable"
    it_behaves_like "can have a location"
  end
end
