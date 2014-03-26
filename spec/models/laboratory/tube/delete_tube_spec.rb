# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/tube_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/tube/delete_tube'
require 'lims-laboratory-app/laboratory/tube'

module Lims::LaboratoryApp
  module Laboratory
    describe Tube::DeleteTube, :tube => true, :laboratory => true, :persistence => true do
      include_context "for application", "test delete tube"
      include_context "tube factory"
      include_context "create object"

      let!(:store) { Lims::Core::Persistence::Store.new }
      let(:tube) { new_tube_with_samples }
      let(:action) {
        described_class.new(:store => store, :user => user, :application => application) do |a,s|
          a.tube = tube 
        end
      }
      subject { action }

      context "valid" do 
        it "deletes a tube" do
          Lims::Core::Persistence::Session.any_instance.should_receive(:delete) 
          result = subject.call
          tube = result[:tube]
          tube.should be_a(Tube)
        end
      end

      context "invalid" do
        it "requires a tube" do
          subject.valid?.should == false
        end
      end
    end
  end
end
