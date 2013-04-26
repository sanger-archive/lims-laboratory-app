# Spec requirements
require 'laboratory/spec_helper'
require 'labels/label_examples'

# Model requirements
require 'lims-laboratory-app/labels/sanger_barcode'

module Lims::LaboratoryApp::Labels

  describe SangerBarcode, :sanger_barcode => true, :barcode => true, :labels => true do
    let(:create_parameters) { {:value => "hello"} }
    it_behaves_like "label"
  end
end
