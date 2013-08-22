# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/tube_rack_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/tube_rack/update_tube_rack'
require 'lims-laboratory-app/laboratory/tube_rack'

module Lims::LaboratoryApp
  module Laboratory
    describe TubeRack::UpdateTubeRack, :tube_rack => true, :laboratory => true, :persistence => true do
      include_context "for application", "test update tube rack"
      include_context "tube_rack factory"
      include_context "create object"

      let!(:store) { Lims::Core::Persistence::Store.new }
      let(:tube_rack) { new_tube_rack_with_samples(5, nil, 100, 5) }
      let(:number_of_rows) { 8 }
      let(:number_of_columns) { 12 }
      let(:aliquot_type) { "DNA" }
      let(:aliquot_quantity) { 5 }
      let(:action) {
        described_class.new(:store => store, :user => user, :application => application) do |a,s|
          a.tube_rack = tube_rack 
          a.aliquot_type = aliquot_type
          a.aliquot_quantity = aliquot_quantity
          a.tubes = tubes
        end
      }
      subject { action }

      context "valid" do
        let(:result) { action.call }
        let(:updated_tube_rack) { result[:tube_rack] }

        context "adding new tubes" do
          let(:tubes) { {"E4" => Tube.new, "G10" => Tube.new, "C1" => Tube.new} }

          it_behaves_like "an action"

          it "updates the tube rack" do
            result.should be_a Hash
            updated_tube_rack.should be_a Laboratory::TubeRack
          end

          it "changes aliquots type in each tube" do
            updated_tube_rack.each do |tube|
              if tube
                tube.each do |aliquot|
                  aliquot.type.should == aliquot_type
                end
              end
            end
          end

          it "changes aliquots quantity in each tube" do
            updated_tube_rack.each do |tube|
              if tube
                tube.each do |aliquot|
                  aliquot.quantity.should == aliquot_quantity
                end
              end
            end
          end

          it "has the new tubes at the right location" do
            updated_tube_rack["E4"].should be_a(Tube)
            updated_tube_rack["G10"].should be_a(Tube)
            updated_tube_rack["C1"].should be_a(Tube)
          end
        end

        context "updating volume of the solvent in new tubes" do
          let(:tubes) {{
            "E4" => {"tube" => Tube.new, "volume" => 10},
            "G10" => {"tube" => Tube.new, "volume" => 15}
          }}

          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.tube_rack = tube_rack 
              a.tubes = tubes
            end
          }

          it_behaves_like "an action"

          it "add the new tubes" do
            updated_tube_rack["E4"].should be_a(Tube)
            updated_tube_rack["G10"].should be_a(Tube)
          end

          it "add a solvent in the new tubes with the right volume" do
            updated_tube_rack["E4"].first.should be_a(Aliquot)
            updated_tube_rack["E4"].first.quantity.should == 10

            updated_tube_rack["G10"].first.should be_a(Aliquot)
            updated_tube_rack["G10"].first.quantity.should == 15
          end
        end

        context "updating volume of the solvent in existing tubes" do
          let(:existing_tube) { tube_rack.first }
          let(:tubes) {{
            "A1" => {"tube" => existing_tube, "volume" => 30}
          }}

          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.tube_rack = tube_rack 
              a.tubes = tubes
            end
          }         

          it_behaves_like "an action"

          it "updates the volume of the solvent in the existing tube" do
            solvent = updated_tube_rack["A1"].find { |aliquot| aliquot.type == Aliquot::Solvent }
            solvent.quantity.should == 30
          end
        end
      end


      context "invalid" do
        context "tubes overriding" do
          let(:tubes) { {"A1" => Tube.new, "G10" => Tube.new, "C1" => Tube.new} }
          it "raises an exception as A1 location is not empty" do
            expect do
              action.call
            end.to raise_error(TubeRack::RackPositionNotEmpty)
          end
        end

        context "update solvent volume" do
          let(:tubes) { {"A1" => {"tube" => Tube.new, "volume" => 50}} }
          it "raises an exception if we try to update solvent volume in a different tube than the existing one" do
            expect do 
              action.call
            end.to raise_error(TubeRack::RackPositionNotEmpty)
          end
        end
      end
    end
  end
end
