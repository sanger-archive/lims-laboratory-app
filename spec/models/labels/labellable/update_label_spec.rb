# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/labels/labellable/labellable_shared'

# Model requirements
require 'lims-laboratory-app/labels/labellable/update_label'
require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    describe Labellable::UpdateLabel do
      include_context "for application", "test update label"
      include_context "labellable factory"
      include_context "create object"

      let!(:store) { Lims::Core::Persistence::Store.new() }
      let(:location) { "00000000-1111-2222-3333-444444444444" } # uuid of an asset (i.e. plate)
      let(:labellable_type) { "resource" }
      let(:labellable) {
        new_labellable_with_labels
      }
      let(:existing_position) { "front barcode" }
      let(:new_position) { "rear barcode" }
      let(:new_type) { "sanger-barcode" }
      let(:new_label_value) { "5678DEF" }

      context "valid calling context" do
        context "update every label properties" do

          let(:content_for_update) { 
            { "position"  => new_position,
              "type"      => new_type,
              "value"     => new_label_value
            }
          }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = labellable
              a.existing_position = existing_position
              a.new_label = content_for_update
            end
          }
          let(:result) { action.call }
          let(:updated_labellable) { result[:labellable] }
          subject { action }

          it_behaves_like "an action"

          it "updates the labellable" do
            result.should be_a Hash
            updated_labellable.should be_a Labels::Labellable
          end

          it "updates the labels in a labellable" do
            updated_labellable.size.should == 1
            updated_labellable[existing_position].should == nil
            updated_labellable[new_position].value.should == new_label_value
            updated_labellable[new_position].type.should == new_type
          end
        end

        context "update some label properties" do
          let(:content_for_update) { 
            { "type"      => new_type,
              "value"     => new_label_value
            }
          }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = labellable
              a.existing_position = existing_position
              a.new_label = content_for_update
            end
          }
          let(:result) { action.call }
          let(:updated_labellable) { result[:labellable] }
          subject { action }

          it_behaves_like "an action"

          it "updates the labellable" do
            result.should be_a Hash
            updated_labellable.should be_a Labels::Labellable
          end

          it "updates the labels in a labellable" do
            updated_labellable.size.should == 1
            updated_labellable[existing_position].should_not == nil
            updated_labellable[existing_position].value.should == new_label_value
            updated_labellable[existing_position].type.should == new_type
          end
        end

        context "update just the position" do
          let!(:existing_value) { labellable[existing_position].value }
          let!(:existing_type) { labellable[existing_position].type }
          let(:content_for_update) { 
            { "position"  => new_position
            }
          }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = labellable
              a.existing_position = existing_position
              a.new_label = content_for_update
            end
          }
          let(:result) { action.call }
          let(:updated_labellable) { result[:labellable] }
          subject { action }

          it_behaves_like "an action"

          it "updates the labellable" do
            result.should be_a Hash
            updated_labellable.should be_a Labels::Labellable
          end

          it "updates the labels in a labellable" do
            updated_labellable.size.should == 1
            updated_labellable[existing_position].should == nil
            updated_labellable[new_position].value.should == existing_value
            updated_labellable[new_position].type.should == existing_type
          end
        end
      end

      context "invalid calling context" do
        context "tries to update label in a labellable with insufficient parameters" do
          let(:content_for_update) { 
            { "test_key" => "test_value" }
          }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = labellable
              a.existing_position = existing_position
              a.new_label = content_for_update
            end
          }
          it "should raise an InsufficientLabelInformationError exception" do
            expect do
              action.call
            end.to raise_error(Lims::LaboratoryApp::Labels::Labellable::InsufficientLabelInformationError)
          end
        end

        context "tries to update label in a not existing position in a labellable" do
          let(:content_for_update) { 
            { "position"  => new_position,
              "type"      => new_type,
              "value"     => new_label_value
            }
          }
          let(:existing_position) { "not_existing_position" }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = labellable
              a.existing_position = existing_position
              a.new_label = content_for_update
            end
          }
          it "should raise an LabelPositionNotExistError exception" do
            expect do
              action.call
            end.to raise_error(Lims::LaboratoryApp::Labels::Labellable::LabelPositionNotExistError)
          end
        end

      end
    end
  end
end
