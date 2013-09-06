# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/plate_and_gel_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/plate/update_plate'
require 'lims-laboratory-app/laboratory/plate'

module Lims::LaboratoryApp
  module Laboratory
    describe Plate::UpdatePlate, :plate => true, :laboratory => true, :persistence => true do
      include_context "for application", "test update tube rack"
      include_context "plate or gel factory"
      include_context "create object"

      let!(:store) { Lims::Core::Persistence::Store.new }
      let(:plate) { new_plate_with_samples }
      let(:number_of_rows) { 8 }
      let(:number_of_columns) { 12 }
      let(:aliquot_type) { "DNA" }
      let(:aliquot_quantity) { 5 }
      let(:result) { action.call }
      let(:updated_plate) { result[:plate] }
      subject { action }

      context "Update plate globally" do
        let(:plate_type) { "new plate type" }
        let(:action) {
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.plate = plate 
            a.aliquot_type = aliquot_type
            a.aliquot_quantity = aliquot_quantity
            a.type = plate_type
          end
        }

        it_behaves_like "an action"

        it "updates the plate" do
          result.should be_a Hash
          updated_plate.should be_a Laboratory::Plate
        end

        it "changes the plate type" do
          updated_plate.type.should == plate_type        
        end

        it "changes aliquots type in each well" do
          updated_plate.each do |well|
            well.each do |aliquot|
              aliquot.type.should == aliquot_type
            end
          end
        end

        it "changes aliquots quantity in each well" do
          updated_plate.each do |well|
            well.each do |aliquot|
              aliquot.quantity.should == aliquot_quantity
            end
          end
        end
      end

      context "Update individual well in the plate" do
        let(:sample_a1) { plate["A1"][1].sample }
        let(:sample_b1) { plate["B1"][1].sample }
        let(:wells_update) { {
          "A1" => {"sample" => sample_a1, "aliquot_type" => aliquot_type, "aliquot_quantity" => aliquot_quantity },
          "B1" => {"sample" => sample_b1, "aliquot_type" => aliquot_type, "aliquot_quantity" => aliquot_quantity }
        }}
        let(:action) {
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.plate = plate
            a.wells = wells_update
          end
        }

        it_behaves_like "an action"

        it "updates the aliquot type in the well A1" do
          ["A1", "B1"].each do |location|
            updated_plate[location].each_with_index do |aliquot, i|
              if i == 1
                aliquot.type.should == aliquot_type
              else
                aliquot.type.should == nil
              end
            end
          end
        end

        it "updates the aliquot quantity in the well A1" do
          ["A1", "B1"].each do |location|
            updated_plate[location].each_with_index do |aliquot, i|
              if i == 1
                aliquot.quantity.should == aliquot_quantity
              else
                aliquot.quantity.should == nil
              end
            end
          end
        end
      end
    end
  end
end
