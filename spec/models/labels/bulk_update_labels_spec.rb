require 'integrations/spec_helper'
require 'models/actions/action_examples'
require 'models/labels/labellable/labellable_shared'

require 'lims-laboratory-app/labels/bulk_update_label'

module Lims::LaboratoryApp
  module Labels
    describe BulkUpdateLabel do

      shared_examples_for "bulk updating labels" do
        it_behaves_like "an action"

        it "updates labellable objects" do
          labellables = result[:labellables]
          labellables.should be_a(Array)
          labellables.each do |labellable|
            labellable.should be_a(Labellable)
            labellable.content.keys.include?(pos1)
            labellable.content.keys.include?(pos2)
          end
          
        end
      end

      include_context "for application", "test bulk update label"
      include_context "labellable factory"
      include_context "use core context service"

      let(:pos1) { "lot_no" }
      let(:pos2) { "barcode" }
      let(:new_label1) { { "s1" => { pos1 => {"value" => "1", "type" => "text"},
                                     pos2 => {"value" => "123", "type" => "sanger-barcode"}} } }
      let(:new_label2) { { "s2" => { pos1 => {"value" => "2", "type" => "text"},
                                     pos2 => {"value" => "465", "type" => "sanger-barcode"}} } }
      let(:parameters) {
        {
          :store => store, 
          :user => user, 
          :application => application,
          :by => "sanger_id",
          :labels => {}.merge!(new_label1).merge!(new_label2)
        }
      }
      let!(:existing_labellable_id1) {
        store.with_session do |session|
          labellable = new_labellable_with_labels(
            name='00000000-1111-2222-3333-444444444444',
            type='resource', 
            position='sanger_id',
            value='s1')
          session << labellable
          uuid = session.uuid_for!(labellable)
          lambda { session.id_for(labellable)}
        end.call
      }
      let!(:existing_labellable_id2) {
        store.with_session do |session|
          labellable = new_labellable_with_labels(
            name='00000000-1111-2222-3333-000000000000',
            type='resource', 
            position='sanger_id',
            value='s2')
          session << labellable
          uuid = session.uuid_for!(labellable)
          lambda { session.id_for(labellable)}
        end.call
      }

      context "invalid action" do
        it "requires a valid by attribute" do
          described_class.new(parameters.merge({:by => "dummy"})).valid?.should == false
        end

        it "requires a labels hash" do
          described_class.new(parameters - [:labels]).valid?.should == false
        end
      end

      context "valid action" do
        let(:result) { subject.call }
        subject {
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.by = parameters[:by]
            a.labels = parameters[:labels]
          end
        }

        it "has valid parameters" do
          described_class.new(parameters).valid?.should == true
        end

        context "with valid sanger ids" do
          it_behaves_like "bulk updating labels"
        end

        context "with invalid sanger ids" do
          let(:new_label1) { { "s3" => { "lot_no" => {"value" => "1", "type" => "text"},
                                         "barcode" => {"value" => "123", "type" => "sanger-barcode"}} } }
          let(:new_label2) { { "s4" => { "lot_no" => {"value" => "2", "type" => "text"},
                                         "barcode" => {"value" => "465", "type" => "sanger-barcode"}} } }

          it "raises an exception" do
            expect {
              subject.call
            }.to raise_error(BulkUpdateLabel::SangerIdNotFound)
          end
        end
      end
    end
  end
end
