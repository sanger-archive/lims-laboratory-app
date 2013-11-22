require 'benchmark/spec_helper'

require 'lims-laboratory-app/laboratory/sample/all'

describe "benchmark 10000 samples", :benchmark => true do
  include_context "use core context service"
  let(:number_of_samples) { 10000 } 
  let(:samples) {
    number_of_samples.times.map do |i|
      sample = Lims::LaboratoryApp::Laboratory::Sample.new("sample_#{i}")
    end
  }

  let(:sample_ids) { 
    store.with_session do |session|
      samples.each { |sample| session << sample }
      lambda { samples.map { |sample| session.sample.id_for(sample) } }
    end.call
  }
  context "creation" do
    it "" do
      expect {
      sample_ids.count.should == number_of_samples
    }.to change { db[:samples].count}.by(10000)
    end
  end

  context "load" do
    before(:each) { sample_ids }
    it "#with no changes" do
      store.with_session do |session|
        loaded_samples = session.sample[sample_ids]
          loaded_samples.count.should == number_of_samples
      end
    end

    context "load" do
      it "#without dirty attribute " do
        store.dirty_attribute_strategy = nil
        store.with_session do |session|
          loaded_samples = session.sample[sample_ids]
          loaded_samples.count.should == number_of_samples
        end
      end
    end
  end
end
