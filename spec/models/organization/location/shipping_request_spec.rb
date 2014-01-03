require 'models/spec_helper'

# Model requirements
require 'lims-laboratory-app/organization/location'
require 'lims-laboratory-app/organization/location/shipping_request'

module Lims::LaboratoryApp::Organization
  describe Location::ShippingRequest do
    # define the parameters for a shipping request
    let(:labware_name)  { "00000000-1111-2222-3333-444444444444" }
    let(:location_name) { "ABC Hospital" }
    let(:address)       { "CB11 3DF Cambridge 123 Sample Way" }
    let(:internal)      { true }
    let(:location)      { Location.new({ 
          :name     => location_name,
          :address  => address,
          :internal => internal
      })
    }

    let(:parameters) {
      { :name     => labware_name,
        :location => location
      }
    }
    let(:excluded_parameters) { [] }

    subject { described_class.new(parameters - excluded_parameters) }

    context "to be valid" do
      it "valid" do
        subject.valid?.should == true
      end
    end

    it_behaves_like "requires", :name
    it_behaves_like "requires", :location

    it_behaves_like "has an attribute of", :name, String
    it_behaves_like "has an attribute of", :location, Location

    context "create the object" do
      it "with the right parameters" do
        subject.name.should     == labware_name
        subject.location.should == location
      end
    end
  end
end
