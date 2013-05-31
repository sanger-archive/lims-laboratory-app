require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "list_actions_for_filter_paper_resource", :filter_paper => true do
  include_context "use core context service"
  it "list_actions_for_filter_paper_resource" do
  # **List actions for filter paper resource.**
  # 
  # * `create` creates a new filter paper via HTTP POST request
  # * `read` returns the list of actions for a filter paper resource via HTTP GET request
  # * `first` lists the first filter papers resources in a page browsing system
  # * `last` lists the last filter papers resources in a page browsing system

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = get "/filter_papers"
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "filter_papers": {
        "actions": {
            "create": "http://example.org/filter_papers",
            "read": "http://example.org/filter_papers",
            "first": "http://example.org/filter_papers/page=1",
            "last": "http://example.org/filter_papers/page=-1"
        }
    }
}
    EOD

  end
end
