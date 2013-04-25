# Spec requirements
require 'laboratory/located_examples'
require 'laboratory/receptacle_examples'
require 'labels/labellable_examples'

# Model requirement
require 'lims-laboratory-app/laboratory/spin_column'

module Lims::LaboratoryApp::Laboratory
  describe SpinColumn, :spin_column => true, :laboratory => true  do
    it_behaves_like "located" 
    it_behaves_like "receptacle"
    it_behaves_like "labellable"
  end
end
