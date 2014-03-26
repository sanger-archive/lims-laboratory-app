require "requests/apiary/16_location_resource/spec_helper"
describe "use_the_create_location_action" do
  include_context "use core context service"
  it "use_the_create_location_action" do
  # **Use the create location action.**
  # 
  # * `name` name of the location
  # * `address` the address of the location
  # * `internal` a boolean value. True if the labware is internal, otherwise false.

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_location", <<-EOD
    {
    "create_location": {
        "name": "ABC Hospital",
        "address": "CB11 3DF Cambridge 123 Sample Way",
        "internal": true
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "create_location": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
            "location": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "name": "ABC Hospital",
                "address": "CB11 3DF Cambridge 123 Sample Way",
                "internal": true
            },
            "uuid": "11111111-2222-3333-4444-555555555555"
        },
        "name": "ABC Hospital",
        "address": "CB11 3DF Cambridge 123 Sample Way",
        "internal": true
    }
}
    EOD

  end
end
