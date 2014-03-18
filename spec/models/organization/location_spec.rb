require 'models/spec_helper'

# Model requirements
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp::Organization
  describe Location do
    # define the parameters for a  location
    let(:name)        { "ABC Hospital" }
    let(:address)     { "CB11 3DF Cambridge 123 Sample Way" }
    let(:internal)    { true }

    let(:parameters)  {
      { :name     => name,
        :address  => address,
        :internal => internal
      }
    }
    let(:excluded_parameters) { [] }

    subject { described_class.new(parameters - excluded_parameters) }

    context "to be valid" do
      it "valid" do
        subject.valid?.should == true
      end
    end

    context "to be valid without internal" do
      let(:excluded_parameters) { [:internal] }
      it "valid" do
        subject.valid?.should == true
      end
    end


    it_behaves_like "requires", :name
    it_behaves_like "requires", :address

    it_behaves_like "has an attribute of", :name, String
    it_behaves_like "has an attribute of", :address, String

    context "create the object" do
      it "with the right parameters" do
        subject.name.should     == name
        subject.address.should  == address
        subject.internal.should == internal
      end
    end
  end
end