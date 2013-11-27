# Spec requirements
require 'models/persistence/sequel/spec_helper'
require 'models/persistence/sequel/store_shared'
require 'models/laboratory/container_like_asset_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/plate/all'
require 'lims-laboratory-app/laboratory/fluidigm/all'
require 'lims-laboratory-app/laboratory/sample'

shared_examples_for "transfer from a plate to a fluidigm" do
  it "transfers the contents of plate to a fluidigm" do
    subject.call
    store.with_session do |session|
      plate = session.plate[plate_id]
      fluidigm = session.fluidigm[fluidigm_id]

      fluidigm["S1"].should_not be_nil
      fluidigm["S1"].each do |aliquot|
        aliquot.type.should == type1
      end
      fluidigm["S3"].should_not be_nil
      fluidigm["S3"].each do |aliquot|
        aliquot.type.should == type1
      end

      plate["A1"].should_not be_nil
      plate["A1"].quantity.should == final_quantity_plate_A1
      plate["C3"].should_not be_nil
      plate["C3"].quantity.should == final_quantity_plate_C3
    end
  end
end

module Lims::LaboratoryApp
  module Laboratory
    describe Plate::TransferPlatesToFluidigm, :plate => true, :transfer => true, :laboratory => true, :persistence => true, :sequel => true do
      include_context "container-like asset factory"

      context "with a sequel store" do
        include_context "sequel store"

        context "and everything already in the database" do
          let(:user) { double(:user) }
          let(:application) { "test transfer plate to fluidigm with a given transfer map" }
          let(:number_of_rows) { 16 }
          let(:number_of_columns) { 12 }

          context "with valid parameters" do
            let(:type1) { "RNA" }
            context "transfer from a plate to a fluidigm" do
              let(:quantity1) { 100 }
              let(:quantity2) { 100 }
              let(:final_quantity_plate_A1) { 40 }
              let(:final_quantity_plate_C3) { 40 }
              let(:plate_id) { save(new_plate_with_samples(5, quantity1)) }
              let(:fluidigm_id) { save(new_empty_fluidigm) }

              subject { described_class.new(:store => store, 
                                            :user => user, 
                                            :application => application) do |action, session|
                plate = session.plate[plate_id]
                fluidigm = session.fluidigm[fluidigm_id]

                action.transfers = [ { "source" => plate,
                                       "source_location" => "A1",
                                       "target" => fluidigm,
                                       "target_location" => "S1",
                                       "fraction" => 0.6,
                                       "aliquot_type" => type1},
                                     { "source" => plate,
                                       "source_location" => "C3",
                                       "target" => fluidigm,
                                       "target_location" => "S3",
                                       "fraction" => 0.6,
                                       "aliquot_type" => type1}
                ]
              end
              }

              it_behaves_like "transfer from a plate to a fluidigm"
            end
          end

        end
      end
    end
  end
end
