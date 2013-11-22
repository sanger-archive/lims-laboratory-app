require "requests/apiary/6_plate_resource/spec_helper"
describe "list_actions_for_tube_rack_resource", :plate => true do
  include_context "use core context service"
  it "list_actions_for_tube_rack_resource" do
  # **List actions for tube rack resource.**
  # 
  # * `create` creates a new plate via HTTP POST request
  # * `read` returns the list of actions for a plate resource via HTTP GET request
  # * `first` lists the first plate resources in a page browsing system
  # * `last` lists the last plate resources in a page browsing system

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/plates"
    response.should match_json_response(200, <<-EOD) 
    {
    "plates": {
        "actions": {
            "create": "http://example.org/plates",
            "read": "http://example.org/plates",
            "first": "http://example.org/plates/page=1",
            "last": "http://example.org/plates/page=-1"
        }
    }
}
    EOD

  end
end
