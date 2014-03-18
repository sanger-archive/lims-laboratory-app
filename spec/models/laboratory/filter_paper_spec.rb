require 'lims-laboratory-app/laboratory/filter_paper'

require 'models/laboratory/spec_helper'
require 'models/laboratory/located_examples'
require 'models/laboratory/location_shared'
require 'models/labels/labellable_examples'
require 'models/laboratory/receptacle_examples'

module Lims::LaboratoryApp::Laboratory
  describe FilterPaper, :filter_paper => true, :laboratory => true do
    it_behaves_like "located"
    it_behaves_like "receptacle"
    it_behaves_like "labellable"
    it_behaves_like "can have a location"
  end
end
