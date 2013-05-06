# Spec requirements
require 'models/laboratory/spec_helper'

# Model requirements
require 'lims-laboratory-app/laboratory/sample'

module Lims::LaboratoryApp::Laboratory
  describe Sample, :sample => true, :laboratory => true do

    context "to be valid" do
      it "requires a name" do
        sample = described_class.new
        sample.valid?.should eq false
      end
    end
  end
end

