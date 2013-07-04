# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'
require 'models/labels/labellable/labellable_shared'

# Model requirements
require 'lims-laboratory-app/labels/labellable/update_labellable'
require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    describe Labellable::UpdateLabellable do
      include_context "for application", "test update labellable"
      include_context "labellable factory"
      include_context "create object"

      let!(:store) { Lims::Core::Persistence::Store.new() }
      let(:name) { "updated_name" }
      let(:type) { "updated_resource" }
      let(:existing_position) { "front barcode" }
      let(:existing_type) { "sanger-barcode" }
      let(:existing_value) { "12345ABC" }
      let(:new_label_value) { "5678DEF" }
      let(:new_label) { Labels::SangerBarcode.new({:value => new_label_value}) }
      let(:new_content) { { new_position => new_label } }
      let(:content_for_update) { [
        { "position"        => existing_position,
          "type"            => existing_type,
          "existing_value"  => existing_value,
          "new_value"       => new_label_value
        }
        ]
      }

      context "valid calling context" do
        context "update label in a labellable" do

          let(:action) { 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = new_labellable_with_labels
              a.name = name
              a.type = type
              a.labels_to_update = content_for_update
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

          it "changes the labellable name" do
            updated_labellable.name = name
          end

          it "changes the labellable type" do
            updated_labellable.type = type
          end

          it "updates the labels in a labellable" do
            updated_labellable.size.should == 1
            updated_labellable[existing_position].value.should_not == existing_value
            updated_labellable[existing_position].value.should == new_label_value
          end
        end
      end

      context "invalid calling context" do
        context "tries to update label in a labellable with insufficient parameters" do
          let(:existing_position) { nil }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = new_labellable_with_labels
              a.name = name
              a.type = type
              a.labels_to_update = content_for_update
            end
          }
          it "should raise an InsufficientLabelInformationError exception" do
            expect do
              action.call
            end.to raise_error(Lims::LaboratoryApp::Labels::Labellable::InsufficientLabelInformationError)
          end
        end

        context "tries to update label in a not existing position in a labellable" do
          let(:existing_position) { "not_existing_position" }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = new_labellable_with_labels
              a.name = name
              a.type = type
              a.labels_to_update = content_for_update
            end
          }
          it "should raise an InsufficientLabelInformationError exception" do
            expect do
              action.call
            end.to raise_error(Lims::LaboratoryApp::Labels::Labellable::LabelPositionNotExistError)
          end
        end

        context "tries to update a non existing label in a labellable" do
          let(:existing_value) { "non-existing-value" }
          let(:action) {
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = new_labellable_with_labels
              a.name = name
              a.type = type
              a.labels_to_update = content_for_update
            end
          }
          it "should raise an InsufficientLabelInformationError exception" do
            expect do
              action.call
            end.to raise_error(Lims::LaboratoryApp::Labels::Labellable::LabelNotExistError)
          end
        end

      end
    end
  end
end
