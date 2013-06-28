# Spec requirements
require 'models/actions/action_examples'
require 'models/persistence/sequel/store_shared'
require 'models/laboratory/tube_shared'
require 'models/laboratory/plate_and_gel_shared'
require 'models/laboratory/spin_column_shared'
require 'models/laboratory/tube_rack_shared'

# Model requirements
require 'lims-laboratory-app/laboratory/sample/swap_samples'
require 'lims-core/persistence/sequel/store'

module Lims::LaboratoryApp
  module Laboratory
    describe Sample::SwapSamples, :laboratory => true, :sample => true, :persistence => true, :sequel => true do
      context "with a sequel store" do
        include_context "for application", "swap samples"
        include_context "sequel store"

        let(:db) { ::Sequel.sqlite('') }
        let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
        before(:each) { prepare_table(db) }

        let(:sample1_uuid) { "11111111-2222-3333-4444-555555555555" }
        let!(:sample1_id) {
          store.with_session do |session|
            sample = Sample.new(:name => "Sample 1")
            session << sample
            session.new_uuid_resource_for(sample).send(:uuid=, sample1_uuid)
            lambda { session.sample.id_for(sample) }
          end.call
        }

        let(:sample2_uuid) { "11111111-2222-3333-4444-666666666666" }
        let!(:sample2_id) {
          store.with_session do |session|
            sample = Sample.new(:name => "Sample 2")
            session << sample
            session.new_uuid_resource_for(sample).send(:uuid=, sample2_uuid)
            lambda { session.sample.id_for(sample) }
          end.call
        }

        let(:sample3_uuid) { "11111111-2222-3333-4444-777777777777" }
        let!(:sample3_id) {
          store.with_session do |session|
            sample = Sample.new(:name => "Sample 3")
            session << sample
            session.new_uuid_resource_for(sample).send(:uuid=, sample3_uuid)
            lambda { session.sample.id_for(sample) }
          end.call
        }

        let(:sample4_uuid) { "11111111-2222-3333-4444-888888888888" }
        let!(:sample4_id) {
          store.with_session do |session|
            sample = Sample.new(:name => "Sample 4")
            session << sample
            session.new_uuid_resource_for(sample).send(:uuid=, sample4_uuid)
            lambda { session.sample.id_for(sample) }
          end.call
        }


        before(:each) { subject.call }

        

        context "with 2 tubes" do
          subject do 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.swap_samples = [
                {
                  "resource" => s.tube[tube_id],
                  "swaps" => {sample1_uuid => sample2_uuid, sample3_uuid => sample4_uuid}
                },
                {
                  "resource" => s.tube[tube2_id],
                  "swaps" => {sample2_uuid => sample3_uuid, sample4_uuid => sample1_uuid}
                }
              ]
            end
          end

          let!(:tube_id) {
            store.with_session do |session|
              tube = Tube.new.tap do |t|
                t << Aliquot.new(:sample => session.sample[sample1_id], :quantity => 5)
                t << Aliquot.new(:sample => session.sample[sample3_id], :quantity => 10)
              end
              session << tube
              lambda { session.tube.id_for(tube) }
            end.call
          }

          let!(:tube2_id) {
            store.with_session do |session|
              tube = Tube.new.tap do |t|
                t << Aliquot.new(:sample => session.sample[sample2_id], :quantity => 20)
                t << Aliquot.new(:sample => session.sample[sample4_id], :quantity => 30)
              end
              session << tube
              lambda { session.tube.id_for(tube) }
            end.call
          }

          context "valid swaps" do
            it "does the swap" do
              store.with_session do |s|
                tube = s.tube[tube_id]
                tube.size.should == 2
                tube[0].sample.should == s.sample[sample2_id]
                tube[0].quantity.should == 5
                tube[1].sample.should == s.sample[sample4_id]
                tube[1].quantity.should == 10

                tube2 = s.tube[tube2_id]
                tube2.size.should == 2
                tube2[0].sample.should == s.sample[sample3_id]
                tube2[0].quantity.should == 20
                tube2[1].sample.should == s.sample[sample1_id]
                tube2[1].quantity.should == 30
              end
            end
          end
        end


        context "with 3 tubes circular swap" do
          subject do 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.swap_samples = [
                {
                  "resource" => s.tube[tube_id],
                  "swaps" => {sample1_uuid => sample3_uuid}
                },
                {
                  "resource" => s.tube[tube2_id],
                  "swaps" => {sample2_uuid => sample1_uuid}
                },
                {
                  "resource" => s.tube[tube3_id],
                  "swaps" => {sample3_uuid => sample2_uuid}
                }
              ]
            end
          end

          let!(:tube_id) {
            store.with_session do |session|
              tube = Tube.new.tap do |t|
                t << Aliquot.new(:sample => session.sample[sample1_id], :quantity => 5)
              end
              session << tube
              lambda { session.tube.id_for(tube) }
            end.call
          }

          let!(:tube2_id) {
            store.with_session do |session|
              tube = Tube.new.tap do |t|
                t << Aliquot.new(:sample => session.sample[sample2_id], :quantity => 10)
              end
              session << tube
              lambda { session.tube.id_for(tube) }
            end.call
          }

          let!(:tube3_id) {
            store.with_session do |session|
              tube = Tube.new.tap do |t|
                t << Aliquot.new(:sample => session.sample[sample3_id], :quantity => 20)
              end
              session << tube
              lambda { session.tube.id_for(tube) }
            end.call
          }

          context "valid swaps" do
            it "does the swap" do
              store.with_session do |s|
                tube = s.tube[tube_id]
                tube.size.should == 1
                tube[0].sample.should == s.sample[sample3_id]
                tube[0].quantity.should == 5

                tube2 = s.tube[tube2_id]
                tube2.size.should == 1
                tube2[0].sample.should == s.sample[sample1_id]
                tube2[0].quantity.should == 10

                tube3 = s.tube[tube3_id]
                tube3.size.should == 1
                tube3[0].sample.should == s.sample[sample2_id]
                tube3[0].quantity.should == 20
              end
            end
          end
        end


        context "with a spin column" do
          subject do 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.swap_samples = [
                {
                  "resource" => s.spin_column[spin_column_id],
                  "swaps" => {sample1_uuid => sample2_uuid, sample3_uuid => sample4_uuid}
                }
              ]
            end
          end

          let!(:spin_column_id) {
            store.with_session do |session|
              spin = SpinColumn.new.tap do |t|
                t << Aliquot.new(:sample => session.sample[sample1_id], :quantity => 5)
              end
              session << spin
              lambda { session.spin_column.id_for(spin) }
            end.call
          }

          context "valid swaps" do
            it "does the swap" do
              store.with_session do |s|
                spin = s.spin_column[spin_column_id]
                spin.size.should == 1
                spin.each do |aliquot|
                  aliquot.sample.should == s.sample[sample2_id]
                  aliquot.quantity.should == 5
                end
              end
            end
          end
        end


        context "with a plate" do
          subject do 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.swap_samples = [
                {
                  "resource" => s.plate[plate_id],
                  "swaps" => {sample1_uuid => sample2_uuid}
                }
              ]
            end
          end

          let(:number_of_rows) { 8 }
          let(:number_of_columns) { 12 }
          let!(:plate_id) {
            store.with_session do |session|
              plate = Plate.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns).tap do |p|
                p[:A1] << Aliquot.new(:sample => session.sample[sample1_id], :quantity => 5)
              end
              session << plate
              lambda { session.plate.id_for(plate) }
            end.call
          }

          it "does the swap" do
            store.with_session do |s|
              plate = s.plate[plate_id]
              plate["A1"].each do |aliquot|
                aliquot.sample.should == s.sample[sample2_id]
              end
            end
          end
        end


        context "with a tube rack" do
          subject do 
            described_class.new(:store => store, :user => user, :application => application) do |a,s|
              a.swap_samples = [
                {
                  "resource" => s.tube_rack[tube_rack_id],
                  "swaps" => {sample1_uuid => sample2_uuid, sample4_uuid => sample3_uuid}
                }
              ]
            end
          end

          let(:number_of_rows) { 8 }
          let(:number_of_columns) { 12 }
          let!(:tube_rack_id) {
            store.with_session do |session|
              rack = TubeRack.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns).tap do |p|
                tube = Tube.new
                tube << Aliquot.new(:sample => session.sample[sample1_id], :quantity => 25)
                p[:A1] = tube 
                tube2 = Tube.new
                tube2 << Aliquot.new(:sample => session.sample[sample4_id], :quantity => 10)
                p[:E5] = tube2
              end
              session << rack
              lambda { session.tube_rack.id_for(rack) }
            end.call
          }

          it "does the swap" do
            store.with_session do |s|
              rack = s.tube_rack[tube_rack_id]
              rack["A1"][0].sample.should == s.sample[sample2_id]
              rack["A1"][0].quantity.should == 25 
              rack["E5"][0].sample.should == s.sample[sample3_id]
              rack["E5"][0].quantity.should == 10 
            end
          end
        end
      end
    end
  end
end
