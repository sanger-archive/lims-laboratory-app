require "requests/apiary/11_flowcell_resource/spec_helper"
describe "list_actions_for_flowcell_resource", :flowcell => true do
  include_context "use core context service"
  it "list_actions_for_flowcell_resource" do
  # **List actions for flowcell resource.**
  # 
  # * `create` creates a new flowcell via HTTP POST request
  # * `read` returns the list of actions for an flowcell resource via HTTP GET request
  # * `first` lists the first flowcells resources in a page browsing system
  # * `last` lists the last flowcells resources in a page browsing system

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/flowcells"
    response.should match_json_response(200, <<-EOD) 
    {
    "flowcells": {
        "actions": {
            "create": "http://example.org/flowcells",
            "read": "http://example.org/flowcells",
            "first": "http://example.org/flowcells/page=1",
            "last": "http://example.org/flowcells/page=-1"
        }
    }
}
    EOD

  end
end
