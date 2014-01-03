# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

#Model requirements
require 'lims-laboratory-app/organization/location/all'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp
  module Organization
    describe Location::CreateShippingRequest, :organization => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        let(:store)       { Lims::Core::Persistence::Store.new }
        let(:user)        { double(:user) }
        let(:application) { "Test for creating a shipping request" }

        # define the parameters for a location
        let(:location_name)        { "ABC Hospital" }
        let(:address)     { "CB11 3DF Cambridge 123 Sample Way" }
        let(:internal)    { true }
        # define the parameters for a shipping request
        let(:labware_name)  { "00000000-1111-2222-3333-444444444444" }
        let(:location) { Location.new(
            { :name     => location_name,
              :address  => address,
              :internal => internal
            })
        }

        context "create a shipping request" do
          subject do
            described_class.new(
              :store        => store,
              :user         => user,
              :application  => application) do |action, session|
                action.name     = labware_name
                action.location = location
            end
          end 

          it_behaves_like "an action"

          it "create a shipping request when called" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:shipping_request].should be_a(Organization::Location::ShippingRequest)
            result[:shipping_request][:name].should     == labware_name
            result[:shipping_request][:location].should == location
            result[:uuid].should == uuid
          end
        end
      end
    end
  end
end
