# Spec requirements
require 'models/persistence/sequel/spec_helper'
require 'models/persistence/sequel/store_shared'

# Model requirements
require 'lims-core/persistence/sequel/store'
require 'lims-laboratory-app/organization/batch'

module Lims::LaboratoryApp
  describe Organization::Batch, :batch => true, :organization => true,  :persistence => true, :sequel => true  do
    include_context "sequel store"

    context "create a batch and add it to session" do
      it "modifies the batches table" do
        expect do
          store.with_session { |s| s << subject }
        end.to change { db[:batches].count }.by(1)
      end

      it "reloads the batch" do
        batch_id = save(subject)
        store.with_session do |session|
          batch = session.batch[batch_id]
          batch.should eq(session.batch[batch_id])
        end
      end

      context "with a process" do
        let(:process) { "process" }
        subject { described_class.new(:process => process) }

        it "can be saved and reloaded" do
          batch_id = save(subject)
          store.with_session do |session|
            batch = session.batch[batch_id]
            batch.process.should == process
          end
        end
      end

      context "with a kit" do
        let(:kit) { "kit" }
        subject { described_class.new(:kit => kit) }

        it "can be saved and reloaded" do
          batch_id = save(subject)
          store.with_session do |session|
            batch = session.batch[batch_id]
            batch.kit.should == kit 
          end
        end       
      end
    end

    context "create a batch but don't add it to a session" do
      it "is not saved" do
        expect do 
          store.with_session { |_| subject }
        end.to change{ db[:batches].count }.by(0)
      end 
    end
  end
end
