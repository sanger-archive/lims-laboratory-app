require 'models/persistence/sequel/store_shared'
require 'models/persistence/sequel/spec_helper'
require 'models/laboratory/tube_shared'
require 'models/laboratory/filter_paper_shared'
require 'models/laboratory/location_shared'

require 'models/persistence/filter/label_sequel_filter_shared'
require 'models/persistence/filter/batch_sequel_filter_shared'
require 'models/persistence/filter/order_lookup_sequel_filter_shared'
require 'models/persistence/filter/multi_criteria_sequel_filter_shared'

require 'lims-laboratory-app/laboratory/filter_paper/all'

module Lims::LaboratoryApp
  describe Laboratory::FilterPaper, :filter_paper => true, :laboratory => true, :persistence => true, :sequel => true do
    include_context "prepare tables"
    include_context "filter paper factory"
    include_context "sequel store"

    context "created and added to session" do
      it "modifies the filter_papers table" do
        expect do
          store.with_session { |s| s << subject }
        end.to change { db[:filter_papers].count }.by(1)
      end

      it "should be reloadable" do
        filter_paper_id = save(subject)
        store.with_session do |session|
          filter_paper = session.filter_paper[filter_paper_id]
          filter_paper.should eq(session.filter_paper[filter_paper_id])
        end
      end

      context "created but not added to a session" do
        it "should not be saved" do
          expect do 
            store.with_session { |_| subject }
          end.to change{ db[:filter_papers].count }.by(0)
        end 
      end

      context "already created filter_paper" do
        let(:aliquot) { new_aliquot }
        let!(:filter_paper_id) { save(subject) }

        context "when modified within a session" do
          before do
            store.with_session do |s|
              filter_paper = s.filter_paper[filter_paper_id]
              filter_paper << aliquot
            end
          end
          it "should be saved" do
            store.with_session do |session|
              filter_paper = session.filter_paper[filter_paper_id]
              filter_paper.should == [aliquot]
            end
          end
        end

        context "when modified outside a session" do
          before do
            filter_paper = store.with_session do |s|
              s.filter_paper[filter_paper_id]
            end
            filter_paper << aliquot
          end
          it "should not be saved" do
            store.with_session do |session|
              filter_paper = session.filter_paper[filter_paper_id]
              filter_paper.should be_empty
            end
          end
        end

        context "created with a location" do
          include_context "define location"
          subject { Laboratory::FilterPaper.new(:location => location) }

          it "can be saved and reloaded" do
            filter_paper_id = save(subject)

            store.with_session do |session|
              filter_paper = session.filter_paper[filter_paper_id]
              filter_paper.location.should == location
            end
          end
        end

        context "when deleted" do
          context "should be deletable" do
            before {
              # add some aliquot to the windows
              store.with_session do |session|
                filter_paper = session.filter_paper[filter_paper_id]
                10.times { |j| filter_paper <<  new_aliquot(1,j) }
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

            it "deletes the filter paper aliquots rows" do
              expect { delete_filter_paper }.to change { db[:filter_paper_aliquots].count}.by(-10)
            end
          end
        end


        context "#lookup" do
          let(:model) { Laboratory::FilterPaper }
          # These uuids match the uuids defined for the order items 
          # in order_lookup_filter_shared.
          let!(:uuids) {
            ['11111111-2222-0000-0000-000000000000',
             '22222222-1111-0000-0000-000000000000',
             '00000000-3333-0000-0000-000000000000'].tap do |uuids|
               uuids.each_with_index do |uuid, index|
                 store.with_session do |session|
                   filter_paper = Laboratory::FilterPaper.new
                   session << filter_paper
                   ur = session.new_uuid_resource_for(filter_paper)
                   ur.send(:uuid=, uuid)
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

      end
    end
  end
end
