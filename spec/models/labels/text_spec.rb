# Spec requirements
require 'models/laboratory/spec_helper'
require 'models/labels/label_examples'

# Model requirements
require 'lims-laboratory-app/labels/text'

module Lims::LaboratoryApp::Labels

  describe Text, :labels => true do
    let(:create_parameters) { {:value => "It is a test text!"} }
    it_behaves_like "label"
  end
end
