require 'models/persistence/sequel/store_shared'

# Model requirements
require 'lims-core/persistence/sequel/store'
require 'lims-core/persistence/sequel/persistor'
require 'lims-laboratory-app/laboratory/snp_assay/snp_assay_persistor'

module Lims::LaboratoryApp::Laboratory
  describe SnpAssay::SnpAssayPersistor do
    include_context "sequel store"

    # define the parameters for an snp_assay
    let(:name)        { "snp_assay name" }
    let(:allele_x)    { Allele::A }
    let(:allele_y)    { Allele::G }
    let(:parameters)  {
      { :name     => name,
        :allele_x => allele_x,
        :allele_y => allele_y
      }
    }
    let(:snp_assay) { SnpAssay.new(parameters) }

    context "when created within a session" do
      it "should modify the snp_assays table" do
        expect do
          store.with_session { |session| session << snp_assay }
        end.to change { db[:snp_assays].count}.by(1)
      end
    end

    it "should save it" do
      snp_assay_id = store.with_session do |session|
        session << snp_assay
        lambda { session.id_for(snp_assay) }
      end.call

      store.with_session do |session|
        session.snp_assay[snp_assay_id]== snp_assay
        session.snp_assay[snp_assay_id].name == snp_assay.name
        session.snp_assay[snp_assay_id].allele_x == snp_assay.allele_x
        session.snp_assay[snp_assay_id].allele_y == snp_assay.allele_y
      end
    end

  end
end