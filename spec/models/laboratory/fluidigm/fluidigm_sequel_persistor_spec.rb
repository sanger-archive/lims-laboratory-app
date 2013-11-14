# Spec requirements
require 'models/persistence/sequel/spec_helper'

require 'models/laboratory/container_like_asset_shared'
require 'models/persistence/resource_shared'
require 'models/persistence/sequel/store_shared'
require 'models/persistence/filter/multi_criteria_sequel_filter_shared'
require 'models/persistence/sequel/page_shared'
require 'models/persistence/filter/label_sequel_filter_shared'
require 'models/persistence/filter/order_lookup_sequel_filter_shared'
require 'models/persistence/filter/batch_sequel_filter_shared'
require 'models/persistence/filter/comparison_lookup_sequel_filter_shared'


# Model requirement
require 'lims-laboratory-app/laboratory/fluidigm/all'

module Lims::LaboratoryApp
  describe "Persistence#Sequel#Fluidigm", :fluidigm => true, :laboratory => true, :persistence => true, :sequel => true do
    include_context "sequel store"
    include_context "container-like asset factory"

    def last_fluidigm_id(session)
      session.fluidigm.dataset.order_by(:id).last[:id]
    end

    context "16*12 Fluidigm" do
      # Set default dimension to create a fluidigm
      let(:number_of_rows) { 16 }
      let(:number_of_columns) { 12 }
      let(:expected_fluidigm_size) { number_of_rows*number_of_columns }

      context do
        let(:number_of_samples) { 3 }
        subject { new_fluidigm_with_samples(number_of_samples) }
        it_behaves_like "storable resource", :fluidigm, 
          {:fluidigms => 1, :fluidigm_wells =>  16*12*3 }
      end

      context "already created fluidigm" do
        let(:aliquot) { new_aliquot }
        before (:each) do
          store.with_session { |session| session << new_empty_fluidigm.tap {|_| _[0] << aliquot} }
        end
        let(:fluidigm_id) { store.with_session { |session| @fluidigm_id = last_fluidigm_id(session) } }

        context "when modified within a session" do
          before do
            store.with_session do |s|
              fluidigm = s.fluidigm[fluidigm_id]
              fluidigm[0].clear
              fluidigm[1]<< aliquot
            end
          end
          it "should be saved" do
            store.with_session do |session|
              f = session.fluidigm[fluidigm_id]
              f[7].should be_empty
              f[1].should == [aliquot]
              f[0].should be_empty
            end
          end
        end
        context "when modified outside a session" do
          before do
            fluidigm = store.with_session do |s|
              s.fluidigm[fluidigm_id]
            end
            fluidigm[0].clear
            fluidigm[1]<< aliquot
          end
          it "should not be saved" do
            store.with_session do |session|
              f = session.fluidigm[fluidigm_id]
              f[7].should be_empty
              f[1].should be_empty
              f[0].should == [aliquot]
            end
          end
        end
        context "should be deletable" do
          before {
            # add some aliquot to the fluidigm_wells
            store.with_session do |session|
            fluidigm = session.fluidigm[fluidigm_id]
            1.upto(10) { |i|  3.times { |j| fluidigm[i] <<  new_aliquot(i,j) } }
            end
          }

          def delete_fluidigm
            store.with_session do |session|
              fluidigm = session.fluidigm[fluidigm_id]
              session.delete(fluidigm)
            end
          end

          it "deletes the fluidigm row" do
            expect { delete_fluidigm }.to change { db[:fluidigms].count}.by(-1)
          end

          it "deletes the fluidigm_well rows" do
            expect { delete_fluidigm }.to change { db[:fluidigm_wells].count}.by(-31)
          end
        end
      end

      context do
        let(:constructor) { lambda { |*_| new_empty_fluidigm } }
        it_behaves_like "paginable resource", :fluidigm
        it_behaves_like "filtrable", :fluidigm
      end
    end
  end
end
