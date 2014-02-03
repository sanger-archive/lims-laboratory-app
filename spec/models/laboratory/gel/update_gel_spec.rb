# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/laboratory/container_like_asset_shared'
require 'models/laboratory/location_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/gel/update_gel'
require 'lims-laboratory-app/laboratory/gel'

module Lims::LaboratoryApp
  module Laboratory
    describe Gel::UpdateGel, :gel => true, :laboratory => true, :persistence => true do
      include_context "for application", "test update gel"
      include_context "container-like asset factory"
      include_context "create object"
      include_context "define location"

      let!(:store) { Lims::Core::Persistence::Store.new }
      let(:gel) { new_gel_with_samples }
      let(:number_of_rows) { 8 }
      let(:number_of_columns) { 12 }
      let(:aliquot_type) { "DNA" }
      let(:aliquot_quantity) { 5 }
      let(:result) { action.call }
      let(:updated_gel) { result[:gel] }
      subject { action }

      context "when updating all the aliquots of the gel" do
        let(:action) {
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.gel = gel 
            a.aliquot_type = aliquot_type
            a.aliquot_quantity = aliquot_quantity
            a.location = location
          end
        }

        it_behaves_like "an action"

        it "updates the gel" do
          result.should be_a Hash
          updated_gel.should be_a Laboratory::Gel
        end

        it "changes aliquots type in each window" do
          updated_gel.each do |window|
            window.each do |aliquot|
              aliquot.type.should == aliquot_type
            end
          end
        end

        it "changes aliquots quantity in each window" do
          updated_gel.each do |window|
            window.each do |aliquot|
              aliquot.quantity.should == aliquot_quantity
            end
          end
        end

        it "changes the gel shipping location" do
          updated_gel.location.should == location
        end
      end


      context "when updating individual window in the gel" do
        let(:sample_a1) { gel["A1"][1].sample }
        let(:sample_b1) { gel["B1"][1].sample }
        let(:windows_update) { {
          "A1" => {"sample" => sample_a1, "aliquot_type" => aliquot_type, "aliquot_quantity" => aliquot_quantity },
          "B1" => {"sample" => sample_b1, "aliquot_type" => aliquot_type, "aliquot_quantity" => aliquot_quantity }
        }}
        let(:action) {
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.gel = gel
            a.windows = windows_update
          end
        }

        it_behaves_like "an action"

        it "updates the aliquot type in the windows A1 and B1" do
          ["A1", "B1"].each do |location|
            updated_gel[location].each_with_index do |aliquot, i|
              if i == 1
                aliquot.type.should == aliquot_type
              else
                aliquot.type.should == nil
              end
            end
          end
        end

        it "updates the aliquot quantity in the windows A1 and B1" do
          ["A1", "B1"].each do |location|
            updated_gel[location].each_with_index do |aliquot, i|
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
