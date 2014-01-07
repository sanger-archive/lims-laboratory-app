require "requests/apiary/17_shipping_request_resource/spec_helper"
describe "list_actions_for_shipping_request_resource", :shipping_request => true do
  include_context "use core context service"
  it "list_actions_for_shipping_request_resource" do
  # **List actions for shipping request resource.**
  # 
  # * `create` creates a new shipping request via HTTP POST request
  # * `read` returns the list of actions for a shipping request resource via HTTP GET request
  # * `first` lists the first shipping request resources in a page browsing system
  # * `last` lists the last shipping request resources in a page browsing system

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/shipping_requests"
    response.should match_json_response(200, <<-EOD) 
    {
    "shipping_requests": {
        "actions": {
            "create": "http://example.org/shipping_requests",
            "read": "http://example.org/shipping_requests",
            "first": "http://example.org/shipping_requests/page=1",
            "last": "http://example.org/shipping_requests/page=-1"
        }
    }
}
    EOD

  end
end
