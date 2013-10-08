require 'models/laboratory/container_like_asset_shared'
require 'models/persistence/resource_shared'
require 'models/persistence/sequel/store_shared'
require 'models/persistence/sequel/spec_helper'

require 'models/persistence/filter/label_sequel_filter_shared'
require 'models/persistence/filter/batch_sequel_filter_shared'
require 'models/persistence/filter/order_lookup_sequel_filter_shared'
require 'models/persistence/filter/multi_criteria_sequel_filter_shared'

require 'lims-laboratory-app/laboratory/filter_paper'

module Lims::LaboratoryApp
  module Laboratory

    shared_context "creating a filter paper with an aliquot" do
      def last_filter_paper_id(session)
        session.filter_paper.dataset.order_by(:id).last[:id]
      end

      let(:aliquot) { new_aliquot }
      before (:each) do
        store.with_session { |session| session << new_empty_filter_paper.tap {|_| _[0] << aliquot} }
      end
      let(:filter_paper_id) { store.with_session { |session| @filter_paper_id = last_filter_paper_id(session) } }
    end

    describe "Persistence#Sequel#FilterPaper" do
      include_context "sequel store"
      include_context "container-like asset factory"

      context "for filter paper with 4 rows and 2 columns" do
        let(:number_of_rows) { 4 }
        let(:number_of_columns) { 2 }
        let(:size) { number_of_rows * number_of_columns }

        context do
          let!(:number_of_sample) { 3 }
          subject { new_filter_paper_with_samples(number_of_sample) }
          it_behaves_like "storable resource", :filter_paper, 
            {:filter_papers => 1, :locations => 4*2*3 }
        end

        context "already created filter paper" do
          include_context "creating a filter paper with an aliquot"

          context "#update" do
            context "when modified within a session" do
              before do
                store.with_session do |s|
                  filter_paper = s.filter_paper[filter_paper_id]
                  filter_paper[0].clear
                  filter_paper[1]<< aliquot
                end
              end
              it "should be saved" do
                store.with_session do |session|
                  f = session.filter_paper[filter_paper_id]
                  f[2].should be_empty
                  f[1].should == [aliquot]
                  f[0].should be_empty
                end
              end
            end
  
            context "when modified outside a session" do
              before do
                filter_paper = store.with_session do |s|
                  s.filter_paper[filter_paper_id]
                end
                filter_paper[0].clear
                filter_paper[1]<< aliquot
              end
              it "should not be saved" do
                store.with_session do |session|
                  f = session.filter_paper[filter_paper_id]
                  f[2].should be_empty
                  f[1].should be_empty
                  f[0].should == [aliquot]
                end
              end
            end
          end

          context "#delete" do
            context "should be deletable" do
              before {
                # add some aliquot to the windows
                store.with_session do |session|
                filter_paper = session.filter_paper[filter_paper_id]
                1.upto(4) { |i|  10.times { |j| filter_paper[i] <<  new_aliquot(i,j) } }
                end
              }
    
              def delete_filter_paper
                store.with_session do |session|
                  filter_paper = session.filter_paper[filter_paper_id]
                  session.delete(filter_paper)
                end
              end
    
              it "deletes the filter_paper row" do
                expect { delete_filter_paper }.to change { db[:filter_papers].count}.by(-1)
              end
    
              it "deletes the locations rows" do
                expect { delete_filter_paper }.to change { db[:locations].count}.by(-41)
              end
            end
          end
        end

        context "#lookup filter paper" do
          include_context "creating a filter paper with an aliquot"
          let(:model) { Laboratory::FilterPaper }
          # These uuids match the uuids defined for the order items 
          # in order_lookup_filter_shared.
          let!(:uuids) {
            ['11111111-2222-0000-0000-000000000000', 
             '22222222-1111-0000-0000-000000000000',
             '00000000-3333-0000-0000-000000000000'].tap do |uuids|
               uuids.each_with_index do |uuid, index|
                 store.with_session do |session|
                   filter_paper =  new_empty_filter_paper.tap { |filter_paper| filter_paper[index] << new_aliquot}
                   session << filter_paper
                   uuid_resource = session.new_uuid_resource_for(filter_paper)
                   uuid_resource.send(:uuid=, uuid)
                 end
               end
             end
          }

          context "by label" do
            let!(:uuid) {
              store.with_session do |session|
                filter_paper = session.filter_paper[filter_paper_id]
                session.uuid_for!(filter_paper)
              end
            }
            it_behaves_like "labels filtrable"
          end

          context "by order" do
            it_behaves_like "orders filtrable"
          end

          context "by batch" do
            it_behaves_like "batch filtrable"
          end
        end

        context "a filter paper is a paginable and filtrable resource" do
          let(:constructor) { lambda { |*_| new_empty_filter_paper } }
          it_behaves_like "paginable resource", :filter_paper
          it_behaves_like "filtrable", :filter_paper
        end
      end

    end
  end
end
