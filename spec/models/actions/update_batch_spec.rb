# Spec requirements
require 'models/actions/spec_helper'
require 'models/actions/action_examples'

# Model requirements
require 'lims-laboratory-app/organization/batch/all'

module Lims::LaboratoryApp
  class Organization::Batch
    describe UpdateBatch do
      context "valid calling context" do
        include_context "for application", "test update batch"
        include_context "create object"

        let(:store) { Lims::Core::Persistence::Store.new }
        let(:process) { "process" }
        let(:kit) { "kit" }
        let(:action) {
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.batch = Organization::Batch.new
            a.process = process
            a.kit = kit
          end
        }
        let(:result) { action.call }
        let(:updated_batch) { result[:batch] }
        subject { action }

        it_behaves_like "an action"

        it "updates the batch" do
          result.should be_a Hash
          updated_batch.should be_a Organization::Batch
        end

        it "changes the process" do
          updated_batch.process.should == process
        end

        it "changes the kit" do
          updated_batch.kit.should == kit
        end
      end
    end
  end
end
