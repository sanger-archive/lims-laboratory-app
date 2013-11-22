require 'benchmark/spec_helper'

require 'lims-laboratory-app/laboratory/plate/all'

describe "benchmark 100 plates", :benchmark => true do
  include_context "use core context service"
  let(:number_of_plates) { 100 } 
  let(:number_of_samples) { number_of_plates*samples_per_well*96 }
  let(:samples_per_well) { 2 }
  let(:plates) {
        number_of_plates.times.map do |i|
          Lims::LaboratoryApp::Laboratory::Plate.new(:number_of_rows => 8, :number_of_columns => 12).tap do |plate|
            plate.each_with_index do |well, index|
              samples_per_well.times do |s|
              sample = Lims::LaboratoryApp::Laboratory::Sample.new("sample_#{i}_#{index}_#{s}")
              well << Lims::LaboratoryApp::Laboratory::Aliquot.new(:sample => sample)
            end
            end
          end
        end
  }

  let(:plate_ids) { 
      store.with_session do |session|
        plates.each { |plate| session << plate }
        lambda { plates.map { |plate| session.plate.id_for(plate) } }
      end.call
  }
  context "creation" do
    it "" do
      store.with_session do |session|
        plates.each { |plate| session << plate }
      end
      store.database[:plates].count.should == number_of_plates
      store.database[:wells].count.should == number_of_samples
      store.database[:aliquots].count.should == number_of_samples
      store.database[:samples].count.should == number_of_samples
    end
  end

  context "update" do
    before(:each) { plate_ids }
    it "#with no changes" do
      #store.dirty_attribute_strategy = Lims::Core::Persistence::Store::DIRTY_ATTRIBUTE_STRATEGY_QUICK_HASH
      benchmark_with_graph do
        store.with_session do |session|
          loaded_plates = session.plate[plate_ids]
        end
      end
    end
    it "#with changes" do
      store.with_session do |session|
        loaded_plates = session.plate[plate_ids]
        loaded_plates.each do |plate|
          # Change the content of one well
          sample = Lims::LaboratoryApp::Laboratory::Sample.new("sample_${i}_${index}")
          plate[0].clear
          plate[0] << Lims::LaboratoryApp::Laboratory::Aliquot.new
        end
      end
    end
  end
end
