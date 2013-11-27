# Spec requirements
require 'models/actions/action_examples'
require 'models/persistence/sequel/store_shared'
require 'models/laboratory/container_like_asset_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/snp_assay/move_snp_assays'
require 'lims-core/persistence/sequel/store'

module Lims::LaboratoryApp
  module Laboratory
    describe SnpAssay::MoveSnpAssays, :laboratory => true, :snp_assay => true, :persistence => true, :sequel => true do
      context "with a sequel store" do
        include_context "for application", "move snp_assays"
        include_context "sequel store"

        let(:allele_x) { Allele::A }
        let(:allele_y) { Allele::G }
        let(:snp_assay1_uuid) { "11111111-2222-3333-4444-555555555555" }
        let!(:snp_assay1_id) {
          store.with_session do |session|
            snp_assay = SnpAssay.new(:name => "SnpAssay 1", :allele_x => allele_x, :allele_y => allele_y)
            session << snp_assay
            session.new_uuid_resource_for(snp_assay).send(:uuid=, snp_assay1_uuid)
            lambda { session.snp_assay.id_for(snp_assay) }
          end.call
        }

        let(:snp_assay2_uuid) { "11111111-2222-3333-4444-666666666666" }
        let!(:snp_assay2_id) {
          store.with_session do |session|
            snp_assay = SnpAssay.new(:name => "SnpAssay 2", :allele_x => allele_x, :allele_y => allele_y)
            session << snp_assay
            session.new_uuid_resource_for(snp_assay).send(:uuid=, snp_assay2_uuid)
            lambda { session.snp_assay.id_for(snp_assay) }
          end.call
        }

        let(:snp_assay3_uuid) { "11111111-2222-3333-4444-777777777777" }
        let!(:snp_assay3_id) {
          store.with_session do |session|
            snp_assay = SnpAssay.new(:name => "SnpAssay 3", :allele_x => allele_x, :allele_y => allele_y)
            session << snp_assay
            session.new_uuid_resource_for(snp_assay).send(:uuid=, snp_assay3_uuid)
            lambda { session.snp_assay.id_for(snp_assay) }
          end.call
        }

        let(:snp_assay4_uuid) { "11111111-2222-3333-4444-888888888888" }
        let!(:snp_assay4_id) {
          store.with_session do |session|
            snp_assay = SnpAssay.new(:name => "SnpAssay 4", :allele_x => allele_x, :allele_y => allele_y)
            session << snp_assay
            session.new_uuid_resource_for(snp_assay).send(:uuid=, snp_assay4_uuid)
            lambda { session.snp_assay.id_for(snp_assay) }
          end.call
        }

        before(:each) { subject.call }

        # A fluidigm containing 2 snp_assay
        context "with a fluidigm" do
          subject do 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.parameters = [
                {
                  "resource"  => s.fluidigm[fluidigm_id],
                  "swaps"     => {  snp_assay1_uuid => snp_assay2_uuid,
                                    snp_assay2_uuid => snp_assay4_uuid,
                                    snp_assay3_uuid => snp_assay1_uuid,
                                    snp_assay4_uuid => snp_assay3_uuid
                                 }
                }
              ]
            end
          end

          let(:number_of_rows) { 16 }
          let(:number_of_columns) { 12 }
          let!(:fluidigm_id) {
            store.with_session do |session|
              fluidigm = Fluidigm.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns).tap do |f|
                f[:S1] << Aliquot.new(:snp_assay => session.snp_assay[snp_assay1_id], :quantity => 5)
                f[:S3] << Aliquot.new(:snp_assay => session.snp_assay[snp_assay2_id], :quantity => 5)
                f[:S5] << Aliquot.new(:snp_assay => session.snp_assay[snp_assay3_id], :quantity => 5)
                f[:S7] << Aliquot.new(:snp_assay => session.snp_assay[snp_assay4_id], :quantity => 5)
              end
              session << fluidigm
              lambda { session.fluidigm.id_for(fluidigm) }
            end.call
          }

          it "does the move" do
            store.with_session do |session|
              fluidigm = session.fluidigm[fluidigm_id]
              fluidigm["S1"].each do |aliquot|
                aliquot.snp_assay.should == session.snp_assay[snp_assay2_id]
              end
              fluidigm["S3"].each do |aliquot|
                aliquot.snp_assay.should == session.snp_assay[snp_assay4_id]
              end
              fluidigm["S5"].each do |aliquot|
                aliquot.snp_assay.should == session.snp_assay[snp_assay1_id]
              end
              fluidigm["S7"].each do |aliquot|
                aliquot.snp_assay.should == session.snp_assay[snp_assay3_id]
              end
            end
          end
        end

      end
    end
  end
end
