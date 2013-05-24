# Spec requirements
require 'models/actions/action_examples'
require 'models/persistence/sequel/store_shared'
require 'models/laboratory/tube_rack_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/tube_rack/tube_rack_transfer'
require 'lims-core/persistence/sequel/store'


module Lims::LaboratoryApp
  module Laboratory
    describe TubeRack::TubeRackTransfer, :tube_rack => true, :transfer => true, :laboratory => true, :persistence => true, :sequel => true do
      context "with a sequel store" do
        include_context "for application", "test tube rack transfer"
        include_context "prepare tables"
        include_context "tube_rack factory"

        let(:number_of_rows) { 8 }
        let(:number_of_columns) { 12 }
        let(:db) { ::Sequel.sqlite('') }
        let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
        before(:each) { prepare_table(db) }

        let(:source_id) {
          store.with_session do |session|
            rack = new_tube_rack_with_samples(1) 
            session << rack
            lambda { session.tube_rack.id_for(rack) }
          end.call
        }

        let(:target_id) {
          store.with_session do |session|
            rack = new_empty_tube_rack.tap do |r|
              r["E9"] = new_empty_tube
            end
            session << rack
            lambda { session.tube_rack.id_for(rack) }
          end.call
        }


        context "invalid action parameters" do
          subject { described_class.new(:store => store, :user => user, :application => application) }

          it "raises an invalid parameters error" do
            expect do
              subject.call
            end.to raise_error(Lims::Core::Actions::Action::InvalidParameters)
          end

          it "contains the errors" do
            begin
              subject.call
            rescue Lims::Core::Actions::Action::InvalidParameters => e
              e.errors.should_not be_empty
            end
          end
        end


        # No tube in target rack B1
        context "invalid transfer" do 
          subject do
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.source = s.tube_rack[source_id]
              a.target = s.tube_rack[target_id]
              a.transfer_map = {:A4 => :B1}
            end
          end

          it "fails" do
            expect { subject.call }.to raise_error(TubeRack::TubeRackTransfer::NoTubeInTargetLocation)
          end
        end


        context "valid transfer" do
          before(:each) { subject.call }
          subject do
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.source = s.tube_rack[source_id]
              a.target = s.tube_rack[target_id]
              a.transfer_map = {:A4 => :E9}
            end
          end

          it "saves the transfered rack" do
            store.with_session do |session|
              source = session.tube_rack[source_id]
              target = session.tube_rack[target_id]
              target[:E9].should_not be_nil
              source[:A4].quantity.should == 0
            end
          end
        end
      end
    end
  end
end
