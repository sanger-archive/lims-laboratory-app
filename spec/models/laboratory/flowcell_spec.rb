# Spec requirements
require 'models/laboratory/spec_helper'
require 'models/laboratory/located_examples'
require 'models/laboratory/container_examples'
require 'models/labels/labellable_examples'

require 'models/laboratory/receptacle_examples'

# Model requirements
require 'lims-laboratory-app/laboratory/flowcell'

module Lims::LaboratoryApp::Laboratory
  shared_examples "contains lanes" do
    its(:size) { should eq(number_of_lanes) } 
    it_behaves_like "a container", Flowcell::Lane

    it "can have a content put in one lane" do
      aliquot = Aliquot.new
      subject[0] << aliquot
      subject[0].should include(aliquot)
    end
    it "can have an aliquot added in one lane" do
      aliquot = Aliquot.new
      subject[0] << aliquot
      subject[0].should include(aliquot)
    end
  end

  describe Flowcell, :flowcell => true, :laboratory => true  do
    subject {described_class.new(:number_of_lanes => number_of_lanes)}
    
    context "of type MiSeq" do
      let (:number_of_lanes) { 1 }
      it_behaves_like "located" 
      it_behaves_like "contains lanes"
      it_behaves_like "labellable"
    end

    context "of type HiSeq" do
      let (:number_of_lanes) { 8 }
      it_behaves_like "located" 
      it_behaves_like "contains lanes"
      it_behaves_like "labellable"
    end
  end
  
  describe Flowcell::Lane, :lane => true, :laboratory => true  do
    it "belongs  to a flowcell "  # contained by a flowcell
    it_behaves_like "receptacle"
  end
end
