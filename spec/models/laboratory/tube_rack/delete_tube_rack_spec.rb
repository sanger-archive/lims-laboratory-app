# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/tube_rack_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/tube_rack/delete_tube_rack'
require 'lims-laboratory-app/laboratory/tube_rack'

module Lims::LaboratoryApp
  module Laboratory
    describe TubeRack::DeleteTubeRack, :tube_rack => true, :laboratory => true, :persistence => true do
      include_context "for application", "test delete tube rack"
      include_context "tube_rack factory"
      include_context "create object"

      let!(:store) { Lims::Core::Persistence::Store.new }
      let(:tube_rack) { new_tube_rack_with_samples(5, nil, 100, 5) }
      let(:number_of_rows) { 8 }
      let(:number_of_columns) { 12 }
      let(:action) {
        described_class.new(:store => store, :user => user, :application => application) do |a,s|
          a.tube_rack = tube_rack 
        end
      }
      subject { action }

      context "valid" do 
        it "deletes a tube rack" do
          Lims::Core::Persistence::Session.any_instance.should_receive(:delete) 
          result = subject.call
          tube_rack = result[:tube_rack]
          tube_rack.should be_a(TubeRack)
        end
      end

      context "invalid" do
        it "requires a tube rack" do
          subject.valid?.should == false
        end
      end
    end
  end
end
