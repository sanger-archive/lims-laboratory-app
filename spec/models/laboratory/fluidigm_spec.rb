# Spec requirements
require 'models/laboratory/spec_helper'
require 'models/laboratory/located_examples'
require 'models/laboratory/container_examples'
require 'models/labels/labellable_examples'

# Model requirements
require 'lims-laboratory-app/laboratory/fluidigm'

module Lims::LaboratoryApp::Laboratory
  shared_examples "a valid fluidigm" do
    it_behaves_like "located" 
    context "contains wells" do
      it_behaves_like "a container", Fluidigm::Well
    end
  end

  describe Fluidigm do
    context "with 12x16 wells" do
      let(:number_of_rows)    { 16 }
      let(:number_of_columns) { 12 }
      let(:size)              { number_of_rows*number_of_columns }

      let(:container) { Fluidigm::Well }
      let(:error_container_does_not_exists) { Fluidigm::IndexOutOfRangeError }

      subject { described_class.new(:number_of_columns => number_of_columns, :number_of_rows =>number_of_rows) }

      its(:number_of_rows) {should == number_of_rows }
      its(:number_of_columns) { should == number_of_columns }
      its(:size) { should eq(size) }

    it_behaves_like "a valid fluidigm"
    it_behaves_like "a hash", :S1, :A4, :B14, :W34
    it_behaves_like "labellable"
    end
  end
end
