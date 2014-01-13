# Spec requirements
require 'models/actions/action_examples'
require 'models/persistence/sequel/store_shared'
require 'models/laboratory/tube_rack_shared'
require 'models/laboratory/location_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/tube_rack/tube_rack_move'
require 'lims-core/persistence/sequel/store'

module Lims::LaboratoryApp
  module Laboratory
    describe TubeRack::TubeRackMove, :tube_rack => true, :move => true, :laboratory => true, :persistence => true, :sequel => true do
      context "with a sequel store" do
        include_context "for application", "test tube rack move"
        include_context "sequel store"
        include_context "tube_rack factory"
        include_context "define location"

        let(:number_of_rows) { 8 }
        let(:number_of_columns) { 12 }

        let(:source1_id) {
          store.with_session do |session|
            rack = new_tube_rack_with_samples(1)
            session << rack
            lambda { session.tube_rack.id_for(rack) }
          end.call
        }

        let(:source2_id) {
          store.with_session do |session|
            rack = new_tube_rack_with_samples(1)
            session << rack
            lambda { session.tube_rack.id_for(rack) }
          end.call
        }

        let(:target1_id) {
          store.with_session do |session|
            rack = target_tube_rack1
            session << rack
            lambda { session.tube_rack.id_for(rack) }
          end.call
        }

        let(:target2_id) {
          store.with_session do |session|
            rack = target_tube_rack2
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

        # Tube already present in target tube rack
        context "invalid transfer" do
          let(:target_tube_rack1) { new_tube_rack_with_samples(1) }

          subject do
            described_class.new(:store => store, :user => user, :application => application) do |action, session|
              action.moves = [
                {"source" => session.tube_rack[source1_id],
                 "source_location" => "A4",
                 "target" => session.tube_rack[target1_id],
                 "target_location" => "E9" }
              ]
            end
          end

          it "fails" do
            expect { subject.call }.to raise_error(Laboratory::TubeRack::RackPositionNotEmpty)
          end
        end

        context "valid transfer" do
          let(:target_tube_rack1) { new_empty_tube_rack }
          let(:target_tube_rack2) { new_empty_tube_rack }
          before(:each) { subject.call }
          it { subject.result.size.should == 2 }
          subject do
            described_class.new(:store => store, :user => user, :application => application) do |action,session|
              source_tube_rack1, source_tube_rack2 = [source1_id, source2_id].map { |uuid| session.tube_rack[uuid] }
              action.moves = [
                {"source" => source_tube_rack1,
                 "source_location" => "A1",
                 "target" => target_tube_rack1,
                 "target_location" => "B9" },
                {"source" => source_tube_rack1,
                 "source_location" => "B2",
                 "target" => target_tube_rack2,
                 "target_location" => "F3" },
                {"source" => source_tube_rack2,
                 "source_location" => "C5",
                 "target" => target_tube_rack1,
                 "target_location" => "D4" },
                {"source" => source_tube_rack2,
                 "source_location" => "E8",
                 "target" => target_tube_rack2,
                 "target_location" => "A9" }
              ]
            end
          end

          it "saves the transfered rack" do
            store.with_session do |session|
              source_tube_rack1, source_tube_rack2 = [source1_id, source2_id].map { |uuid| session.tube_rack[uuid] }
              source_tube_rack1[:A1].should be_nil
              source_tube_rack1[:B2].should be_nil
              source_tube_rack2[:C5].should be_nil
              source_tube_rack2[:E8].should be_nil

              target_tube_rack1[:B9].should_not be_nil
              target_tube_rack1[:B9].should be_a(Lims::LaboratoryApp::Laboratory::Tube)
              target_tube_rack1[:D4].should_not be_nil
              target_tube_rack1[:D4].should be_a(Lims::LaboratoryApp::Laboratory::Tube)
              target_tube_rack2[:F3].should_not be_nil
              target_tube_rack2[:F3].should be_a(Lims::LaboratoryApp::Laboratory::Tube)
              target_tube_rack2[:A9].should_not be_nil
              target_tube_rack2[:A9].should be_a(Lims::LaboratoryApp::Laboratory::Tube)
            end
          end
        end
      end
    end
  end
end
