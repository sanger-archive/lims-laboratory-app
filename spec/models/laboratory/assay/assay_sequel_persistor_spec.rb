require 'models/persistence/sequel/store_shared'

# Model requirements
require 'lims-core/persistence/sequel/store'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/assay/assay_persistor'

module Lims::LaboratoryApp::Laboratory
  describe Assay::AssayPersistor do
    include_context "sequel store"

    # define the parameters for an assay
    let(:name)        { "assay name" }
    let(:allele_x)    { Allele::A }
    let(:allele_y)    { Allele::G }
    let(:parameters)  {
      { :name     => name,
        :allele_x => allele_x,
        :allele_y => allele_y
      }
    }
    let(:assay) { Assay.new(parameters) }

    context "when created within a session" do
      it "should modify the assays table" do
        expect do
          store.with_session { |session| session << assay }
        end.to change { db[:assays].count}.by(1) 
      end
    end

    it "should save it" do
      assay_id = store.with_session do |session|
        session << assay
        lambda { session.id_for(assay) }
      end.call

      store.with_session do |session|
        session.assay[assay_id]== assay
        session.assay[assay_id].name == assay.name
        session.assay[assay_id].allele_x == assay.allele_x
        session.assay[assay_id].allele_y == assay.allele_y
      end
    end

  end
end