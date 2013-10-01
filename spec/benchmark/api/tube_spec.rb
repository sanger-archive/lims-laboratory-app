require 'benchmark'
require 'benchmark/spec_helper'

require 'lims-laboratory-app/laboratory/all'

def create_tubes_parameter(quantity)
  [].tap do |tubes|
    (0..quantity).to_a.each do |i|
      tubes << {"type" => "type#{i}", "max_volume" => i, "aliquots" => []}
    end
  end
end

shared_examples "creating n tubes" do |n|
  context "#{n} empty tubes", :size => n do
    let!(:parameters) { {:bulk_create_tube => {:tubes => create_tubes_parameter(n)}} }
    it "bulk creates #{n} tubes" do
      result = benchmark_with_graph do
        post('/actions/bulk_create_tube', JSON(parameters))
      end
      result.status.should == 200
    end
  end
end

describe "benchmark tube creation", :benchmark => true do
  include_context "use core context service"
  include_context "JSON"
  it_behaves_like "creating n tubes", 100
  it_behaves_like "creating n tubes", 500
  it_behaves_like "creating n tubes", 1000
  it_behaves_like "creating n tubes", 5000
end
