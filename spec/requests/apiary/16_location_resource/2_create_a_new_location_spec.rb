require "requests/apiary/16_location_resource/spec_helper"
describe "create_a_new_location" do
  include_context "use core context service"
  it "create_a_new_location" do
  # **Create a location resource.**
  # 
  # * `name` name of the location
  # * `address` the address of the location
  # * `internal` a boolean value. True if the labware is internal, otherwise false.

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/locations", <<-EOD
    {
    "location": {
        "name": "ABC Hospital",
        "address": "CB11 3DF Cambridge 123 Sample Way",
        "internal": false
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "location": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "name": "ABC Hospital",
        "address": "CB11 3DF Cambridge 123 Sample Way",
        "internal": false
    }
}
    EOD

  end
end
