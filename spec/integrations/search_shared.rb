require 'search_shared'

shared_context "execute search" do
  let(:parameters) { {:search => {:description => description, :model => searched_model, :criteria => criteria}} }
  let(:search_result) { JSON.parse(post("/#{model}", parameters.to_json).body) }
  let(:first_page) { search_result["search"]["actions"]["first"] }
  let(:result_first_page) { get(first_page) }
  let!(:found_resources) { JSON.parse(result_first_page.body) }
end


shared_examples_for "search" do |expected_uuids|
  context "create a search resource" do
    let(:parameters) { {:search => {:description => description, :model => searched_model, :criteria => criteria}} }
    let(:expected_json) {
      path = "http://example.org/#{uuid}"
      {"search" => {"actions" => {"read" => path,
                                  "first" => "#{path}/page=1",
                                  "last" => "#{path}/page=-1"},
                    "uuid" => uuid}}
    }
    it_behaves_like "creating a resource"
  end

  context "found resources" do
    include_context "execute search"

    it "has actions" do
      search_result["search"]["actions"].should be_a(Hash)      
    end

    it "is successful" do
      result_first_page.status.should == 200      
    end

    it "gets the expected resources" do
      found_resources["size"] == expected_uuids.size 
      found_uuids = found_resources[searched_model.pluralize].map { |resource| resource["uuid"] }
      found_uuids.sort.should == expected_uuids.sort
    end
 end
end


shared_examples_for "empty search" do
  it_behaves_like "search", [] 
end


shared_context "search by label" do
  context "searching by their position" do
    let(:criteria) { { :label => { :position => label_position } } }
    it_behaves_like "search", ["11111111-1111-0000-0000-000000000000",
                         "11111111-1111-0000-0000-000000000001",
                         "11111111-1111-0000-0000-000000000002",
                         "11111111-1111-0000-0000-000000000003",
                         "11111111-1111-0000-0000-000000000004"] 
  end

  context "searching by their uuid (value) and type" do
    let(:criteria) { { :label => { :value => asset_uuids[0], :type => label_type } } }
    it_behaves_like "search", ["11111111-1111-0000-0000-000000000000"]
  end

  context "searching by their uuid (value) and position" do
    let(:criteria) { { :label => { :value => asset_uuids[0], :position => label_position } } }
    it_behaves_like "search", ["11111111-1111-0000-0000-000000000000"]
  end
end


shared_context "search by order" do  
  context "by order pipeline" do
    let(:criteria) { {:order => {:pipeline => "P1"}} }
    it_behaves_like "search", ["11111111-1111-0000-0000-000000000000", 
                               "11111111-1111-0000-0000-000000000001",
                               "11111111-1111-0000-0000-000000000002"]
  end

  context "by order status" do
    let(:criteria) { {:order => {:status => "in_progress"}} }
    it_behaves_like "search", ["11111111-1111-0000-0000-000000000000", 
                               "11111111-1111-0000-0000-000000000001",
                               "11111111-1111-0000-0000-000000000002"]
  end

  context "by order items" do
    let(:criteria) { {:order => {:item => {:status => "pending"}}} }
    it_behaves_like "search", ["11111111-1111-0000-0000-000000000002",
                               "11111111-1111-0000-0000-000000000004"]
  end
end
