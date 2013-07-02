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
      context "valid calling context" do
        include_context "for application", "test update labellable" 
        include_context "labellable factory"
        include_context "create object"

        let!(:store) { Lims::Core::Persistence::Store.new() }
        let(:name) { "updated_name" }
        let(:type) { "updated_resource" }
        let(:new_position) { "updated_position" }
        let(:new_label_value) { "updated_label_value" }
        let(:new_label) { Labels::SangerBarcode.new({:value => new_label_value}) }
        let(:new_content) { { new_position => new_label } }

        context "add new labels to a labellable" do
          let(:action) { 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.labellable = new_labellable_with_labels
              a.name = name
              a.type = type
              a.new_labels = new_content
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
  
          it "adds labels to a labellable" do
            updated_labellable.size.should == 2
            updated_labellable[new_position].should be_a Labels::Labellable::Label
            updated_labellable[new_position].value.should == new_label_value
          end
        end

        context "update label in a labellable" do
          let(:content_for_update) { [
            { "original_label" => {
                "position" => "front barcode",
                "type"     => "sanger-barcode",
                "value"    => "12345ABC"},
              "value_for_update" => "5678DEF"
            }
            ]
          }
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
          end
        end
      end
    end
  end
end
