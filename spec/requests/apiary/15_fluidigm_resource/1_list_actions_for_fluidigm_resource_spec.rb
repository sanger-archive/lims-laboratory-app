require "requests/apiary/15_fluidigm_resource/spec_helper"
describe "list_actions_for_fluidigm_resource", :fluidigm => true do
  include_context "use core context service"
  it "list_actions_for_fluidigm_resource" do
  # **List actions for fluidigm resource.**
  # 
  # * `create` creates a new fluidigm via HTTP POST request
  # * `read` returns the list of actions for a fluidigm resource via HTTP GET request
  # * `first` lists the first fluidigms resources in a page browsing system
  # * `last` lists the last fluidigms resources in a page browsing system

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/fluidigms"
    response.should match_json_response(200, <<-EOD) 
    {
    "fluidigms": {
        "actions": {
            "create": "http://example.org/fluidigms",
            "read": "http://example.org/fluidigms",
            "first": "http://example.org/fluidigms/page=1",
            "last": "http://example.org/fluidigms/page=-1"
        }
    }
}
    EOD

  end
end
