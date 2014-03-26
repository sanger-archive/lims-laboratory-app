# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/persistence/sequel/store_shared'

# Model requirements
require 'lims-laboratory-app/organization/location/all'
require 'lims-laboratory-app/laboratory/tube/all'

module Lims::LaboratoryApp
  class Organization::Location
    describe UpdateLocation do
      context "valid calling context" do
        include_context "for application", "test update location"
        include_context "create object"
        include_context "sequel store"

        let(:address)             { "CB2 1WE old address" }
        let(:name)                { "old name" }
        let(:internal)            { true }
        let(:location_to_update)  { Organization::Location.new({
            :name => name,
            :address => address,
            :internal => internal})
        }
        let(:new_address)   { "FG3 5RT updated address" }
        let(:new_name)      { "updated name" }
        let(:new_internal)  { false }
        # labwares_to_update
        let(:tubes) { 3.times.map do
          Lims::LaboratoryApp::Laboratory::Tube.new(:location => location_to_update)
        end
        }
        let(:labwares_to_update) {
          store.with_session do |session|
            uuids = tubes.map { |tube| 
                session << tube
                session.uuid_for!(tube)
              }
            lambda { uuids }
          end.call
        }
        let(:parameters) {
          {
            :store => store,
            :user => user,
            :application => application,
            :location       => location_to_update,
            :name           => new_name,
            :address        => new_address,
            :internal       => new_internal,
            :labware_uuids  => labwares_to_update
          }
        }
        let(:action) {
          described_class.new(parameters)
        }

        it "is a valid action" do
          action.call
          action.valid?.should == true
        end

        it "is a valid action without internal parameter" do
          described_class.new(parameters - [:internal]).valid?.should == true
        end

        let(:result) { action.call }
        let(:updated_location) { result[:location] }
        subject { action }

        it_behaves_like "an action"

        it "updates the location" do
          result.should be_a(Hash)
          updated_location.should be_a(Organization::Location)
        end

        it "changes the name" do
          updated_location.name.should == new_name
        end

        it "changes the address" do
          updated_location.address.should == new_address
        end

        it "changes the internal flag" do
          updated_location.internal.should == new_internal
        end

        it "changes the location of the labwares" do
          action.call
          tubes.each do |tube|
            tube.location.name.should == new_name
            tube.location.address.should == new_address
            tube.location.internal.should == new_internal
          end
        end
      end
    end
  end
end
