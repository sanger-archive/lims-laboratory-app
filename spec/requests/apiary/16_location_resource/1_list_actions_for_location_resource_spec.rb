require "requests/apiary/16_location_resource/spec_helper"
describe "list_actions_for_location_resource" do
  include_context "use core context service"
  it "list_actions_for_location_resource" do
  # **List actions for location resource.**
  # 
  # * `create` creates a new location via HTTP POST request
  # * `read` returns the list of actions for a location resource via HTTP GET request
  # * `first` lists the first location resources in a page browsing system
  # * `last` lists the last location resources in a page browsing system

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/locations"
    response.should match_json_response(200, <<-EOD) 
    {
    "locations": {
        "actions": {
            "create": "http://example.org/locations",
            "read": "http://example.org/locations",
            "first": "http://example.org/locations/page=1",
            "last": "http://example.org/locations/page=-1"
        }
    }
}
    EOD

  end
end
