# Spec requirements
require 'models/persistence/sequel/spec_helper'

require 'models/laboratory/container_like_asset_shared'
require 'models/persistence/resource_shared'
require 'models/persistence/sequel/store_shared'
require 'models/persistence/filter/multi_criteria_sequel_filter_shared'
require 'models/persistence/filter/label_sequel_filter_shared'
require 'models/persistence/filter/order_lookup_sequel_filter_shared'
require 'models/persistence/filter/batch_sequel_filter_shared'
require 'models/persistence/filter/comparison_lookup_sequel_filter_shared'
require 'models/laboratory/location_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/plate/all'

module Lims::LaboratoryApp

  describe "Sequel#Plate ", :plate => true, :laboratory => true, :persistence => true, :sequel => true do
    include_context "sequel store"
    include_context "container-like asset factory"
    include_context "define location"

    def last_plate_id(session)
      session.plate.dataset.order_by(:id).last[:id]
    end

    context "8*12 Plate" do
      # Set default dimension to create a plate
      let(:number_of_rows) { 8 }
      let(:number_of_columns) { 12 }
      let(:expected_plate_size) { number_of_rows*number_of_columns }

      context do
        subject { new_plate_with_samples(3) }
        it_behaves_like "storable resource", :plate, {:plates => 1, :wells =>  8*12*3 }
      end

      context "already created plate" do
        let(:aliquot) { new_aliquot }
        before (:each) do
          store.with_session { |session| session << new_empty_plate.tap {|_| _[0] << aliquot} }
        end
        let!(:plate_id) { store.with_session { |session| @plate_id = last_plate_id(session) } }

        context "when modified within a session" do
          before do
            store.with_session do |s|
              plate = s.plate[plate_id]
              plate[0].clear
              plate[1]<< aliquot
            end
          end
          it "should be saved" do
            store.with_session do |session|
              f = session.plate[plate_id]
              f[7].empty_resource?.should be_true
              f[1].should == [aliquot]
              f[0].empty_resource?.should be_true
            end
          end
        end
        context "when modified outside a session" do
          before do
            plate = store.with_session do |s|
              s.plate[plate_id]
            end
            plate[0].clear
            plate[1]<< aliquot
          end
          it "should not be saved" do
            store.with_session do |session|
              f = session.plate[plate_id]
              f[7].empty_resource?.should be_true
              f[1].empty_resource?.should be_true
              f[0].should == [aliquot]
            end
          end
        end
        context "should be deletable" do
          before {
            # add some aliquot to the wells
            store.with_session do |session|
            plate = session.plate[plate_id]
            1.upto(10) { |i|  3.times { |j| plate[i] <<  new_aliquot(i,j) } }
            end
          }

          def delete_plate
            store.with_session do |session|
              plate = session.plate[plate_id]
              session.delete(plate)
            end
          end

          it "deletes the plate row" do
            expect { delete_plate }.to change { db[:plates].count}.by(-1)
          end

          it "deletes the well rows" do
            expect { delete_plate }.to change { db[:wells].count}.by(-31)
          end
          it "deletes the aliquot rows" do
            expect { delete_plate }.to change { db[:aliquots].count}.by(-31)
          end
        end

        context "with a plate type" do
          let(:type) { "plate type" }
          subject { Laboratory::Plate.new(:number_of_rows => number_of_rows,
                                          :number_of_columns => number_of_columns,
                                          :type => type) }

          it "can be saved and reloaded" do
            plate_id = save(subject)                        
            store.with_session do |session|
              plate = session.plate[plate_id]
              plate.type.should == type
            end
          end
        end

        context "with a location" do
          subject { Laboratory::Plate.new(:number_of_rows => number_of_rows,
                                          :number_of_columns => number_of_columns,
                                          :location => location) }
          it "can be saved and reloaded" do
            plate_id = save(subject)

            store.with_session do |session|
              plate = session.plate[plate_id]
              plate.location.should == location
            end
          end
        end


        context "#lookup" do
          let(:model) { Laboratory::Plate }
          # These uuids match the uuids defined for the order items 
          # in order_lookup_filter_shared.
          let!(:uuids) {
            ['11111111-2222-0000-0000-000000000000', 
             '22222222-1111-0000-0000-000000000000',
             '00000000-3333-0000-0000-000000000000'].tap do |uuids|
               uuids.each_with_index do |uuid, index|
                 store.with_session do |session|
                   plate =  new_empty_plate.tap { |plate| plate[index] << new_aliquot}
                   session << plate
                   ur = session.new_uuid_resource_for(plate)
                   ur.send(:uuid=, uuid)
                 end
               end
             end
          }

          context "by comparison" do
            it_behaves_like "comparison filter for plate"
          end

          context "by label" do
            let!(:uuid) {
              store.with_session do |session|
                plate = session.plate[plate_id]
                session.uuid_for!(plate)
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
      pending do
        context "#dirty-attribute" do
          let!(:plate_id) { save(new_plate_with_samples) }
          context "no strategy" do
            before(:each) { store.dirty_attribute_strategy = nil }
            it "saves everything" do
              store.with_session do |session|
                session.plate.should_receive(:update_raw).and_call_original
                session.aliquot.should_receive(:save_all).exactly(96*5).and_call_original
                session.aliquot.should_receive(:update_raw).exactly(96*5).and_call_original
                plate = session.plate[plate_id]
              end
            end
          end
          context "strategy" do
            before(:each) { store.dirty_attribute_strategy = store.class::DIRTY_ATTRIBUTE_STRATEGY_SHA1 }
            it "saves everything" do
              store.with_session do |session|
                session.plate.should_not_receive(:update_raw)
                session.aliquot.should_not_receive(:update_raw)
                session.aliquot.should_receive(:save_all).exactly(96*5).and_call_original
                plate = session.plate[plate_id]
              end
            end
          end
        end
      end

      context do
        let(:constructor) { lambda { |*_| new_empty_plate } }
        it_behaves_like "paginable resource", :plate
        it_behaves_like "filtrable", :plate
      end
    end
  end
end
