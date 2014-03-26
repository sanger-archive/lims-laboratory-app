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
    let(:post_result) { post('/actions/bulk_create_tube', JSON(parameters)) }

    it "bulk creates #{n} tubes" do
      result = benchmark_with_graph("create_#{n}_tubes") do
        post_result
      end
      result.status.should == 200
    end

    it "displays them" do
      post_result
      # We need to change the number of item per pages
      # to get them all in one page.
      # However it needs to be slightly bigger than the expected
      # number in case there are too many.
      Lims::Api::CoreClassResource::NUMBER_PER_PAGES=n*2

      response  = nil
      benchmark_with_graph("display tube pages") do
         response = get "/tubes/page=1"
      end
        tubes = JSON::parse(response.body)
        tubes["tubes"].size.should == n+1
    end

  end
end

describe "benchmark tube creation", :benchmark => true do
  include_context "use core context service"
  include_context "JSON"
  it_behaves_like "creating n tubes", 1
  it_behaves_like "creating n tubes", 100
  it_behaves_like "creating n tubes", 500
  it_behaves_like "creating n tubes", 1000
  it_behaves_like "creating n tubes", 5000
end
