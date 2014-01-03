# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

#Model requirements
require 'lims-laboratory-app/organization/location/all'
require 'lims-core/persistence/store'

module Lims::LaboratoryApp
  module Organization
    describe Location::CreateLocation, :organization => true, :persistence => true do
      context "with a valid store" do
        include_context "create object"
        let(:store) { Lims::Core::Persistence::Store.new }
        let(:user) { double(:user) }
        let(:application) { "Test for creating a location" }

        # define the parameters for a location
        let(:name)        { "ABC Hospital" }
        let(:address)     { "CB11 3DF Cambridge 123 Sample Way" }
        let(:internal)    { true }

        context "create a location" do
          subject do
            described_class.new(
              :store        => store,
              :user         => user,
              :application  => application) do |action, session|
                action.name     = name
                action.address  = address
                action.internal = internal
            end
          end 

          it_behaves_like "an action"

          it "create a location when called" do
            Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
            result = subject.call
            result.should be_a(Hash)
            result[:location].should be_a(Organization::Location)
            result[:location][:name].should == name
            result[:location][:address].should == address
            result[:location][:internal].should == internal
            result[:uuid].should == uuid
          end
        end
      end
    end
  end
end