require 'models/spec_helper'

# Model requirements
require 'lims-laboratory-app/laboratory/snp_assay'
require 'lims-laboratory-app/laboratory/allele'
module Lims::LaboratoryApp::Laboratory
  describe SnpAssay do

    # define the parameters for an snp_assay
    let(:name)        { "snp_assay name" }
    let(:allele_x)    { Allele::A }
    let(:allele_y)    { Allele::G }
    let(:parameters)  {
      { :name     => name,
        :allele_x => allele_x,
        :allele_y => allele_y
      }
    }
    let(:excluded_parameters) { [] }

    context "to be valid" do
      subject { described_class.new(parameters - excluded_parameters) }
      it "valid" do
        subject.valid?.should == true
      end

      it_behaves_like "requires", :name
      it_behaves_like "requires", :allele_x
      it_behaves_like "requires", :allele_y

      it_behaves_like "has an attribute of", :name, String
      it_behaves_like "has an attribute of", :allele_x, String
      it_behaves_like "has an attribute of", :allele_y, String
    end
  end
end
